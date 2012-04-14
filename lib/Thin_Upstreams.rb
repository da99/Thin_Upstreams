require 'Thin_Upstreams/version'
require "yaml"

def Thin_Upstreams glob = "./*/config/thin.yml"

  str = %~\n~
  arr = Dir.glob(glob).each { |file|
      o = YAML::load File.read(file)
      app_name = begin
                   pwd  = File.join( File.expand_path("."), "/" )
                   path = File.expand_path(file)
                   path.sub(pwd, '').split("/").first
                 end
      
      ports = Thin_Upstreams.port_to_array(o["port"], o["servers"])
      str << %~
        upstream #{app_name} {
          #{ ports.map { |i| "server 127.0.0.1:#{i}" }.join(";\n") };
        }
      ~
    }

  File.write "upstreams.conf", str
end

class Thin_Upstreams
  
  module Class_Methods

    def port_to_array raw_port, raw_num
      port = Integer(raw_port)
      q    = Integer(raw_num)
      (0...q).to_a.map { |i| port + i }
    end

  end # === module Class_Methods
  
  extend Class_Methods
  
end # === class Thin_Upstreams
