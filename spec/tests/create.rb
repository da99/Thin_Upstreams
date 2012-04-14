
describe "Thin_Upstreams" do
  
  behaves_like "file_maker"
  
  it "creates upstreams.conf file" do
    chdir {
      Thin_Upstreams()
      File.file?("upstreams.conf").should == true
    }
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
  
end # === Thin_Upstreams

