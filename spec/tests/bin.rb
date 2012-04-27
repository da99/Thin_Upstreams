
bins = Dir.glob("bin/*")

describe "permissions of bin/" do
  bins.each { |file|
    it "should chmod 755 for: #{file}" do
      `stat -c %a #{file}`.strip
      .should.be == "755"
    end
  }
end # === permissions of bin/

describe "Thin_Upstreams (bin executable)" do

  behaves_like "file_maker"

  it "creates upstreams.conf file" do
    target = "upstream Hi"
    chdir {
      Exit_0 "Thin_Upstreams"
      File.read("upstreams.conf")[target].should == target
    }
  end
  
  it "accepts a file glob" do
    target = ":601"
    chdir {
      Exit_0 "Thin_Upstreams \"*/custom/*.yml\""
      File.read("upstreams.conf")[target].should == target
    }
  end
  
end # === Thin_Upstreams (bin executable)

