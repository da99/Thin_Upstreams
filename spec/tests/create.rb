
describe "Thin_Upstreams" do
  
  behaves_like "file_maker"
  
  it "creates upstreams.conf file" do
    chdir {
      Thin_Upstreams()
      File.file?("upstreams.conf").should == true
    }
  end

  unless `which nginx`.strip.empty?
    it "creates upstreams.conf file that validates when included in NGIX conf." do
      chdir {
        Thin_Upstreams()
        path = File.expand_path("upstreams.conf")
        nginx = File.expand_path("nginx.conf")
        File.write "nginx.conf", %!
          user www-data;
          worker_processes 4;
          pid /var/run/nginx.pid;

          events {
            worker_connections 768;
            # multi_accept on;
          }

          http {
            error_log #{File.dirname(path) + "/error.log"};
            sendfile on;
            tcp_nopush on;
            tcp_nodelay on;
            keepalive_timeout 65;
            types_hash_max_size 2048;
            include #{path};
            server {
              location / {
                proxy_pass http://Hi;
              }
            }
          }
        !
        `nginx -t -c #{nginx} 2>&1`
        .should.match %r!the configuration file /tmp/Thin_Upstreams/nginx.conf syntax is ok!
      }
    end
  end

  it "generates content based on: */config/thin.yml" do
    target = "upstream Hi"
    chdir {
      Thin_Upstreams()
      File.read("upstreams.conf")[target].should == target
      %w{ 3010 3011 4010 4011 4012 }.each { |port| 
        File.read("upstreams.conf")[":#{port}"].should == ":#{port}"
      }
    }
  end

  it "allows custom file globs" do
    chdir {
      Thin_Upstreams "*/custom/my.yml"
      %w{ 6010 6011 6012 7010 7011 7012 }.each { |port| 
        File.read("upstreams.conf")[":#{port}"].should == ":#{port}"
      }
    }
  end
  
  it "accepts thin.yml files without :servers as a key" do
    chdir {
      Thin_Upstreams "*/thin.yml"
      %w{ 7020 }.each { |port|
        File.read('upstreams.conf')[":7020"].should == ":7020"
      }
    }
  end

end # === Thin_Upstreams

