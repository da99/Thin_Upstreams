
require File.expand_path('spec/helper')
require 'Thin_Upstreams'
require 'Bacon_Colored'
require 'pry'
require 'Exit_0'

DIR = "/tmp/Thin_Upstreams"

def chdir
  Dir.chdir(DIR) {
    yield
  }
end

def reset_dir
  Exit_0 "rm -rf #{DIR}"
  
  Exit_0 "mkdir -p #{DIR}/Hi/config"
  Exit_0 "mkdir -p #{DIR}/Hi/custom"
  
  Exit_0 "mkdir -p #{DIR}/Hello/config"
  Exit_0 "mkdir -p #{DIR}/Hello/custom"
  Exit_0 "mkdir -p #{DIR}/No_Servers"
  
  File.write "#{DIR}/No_Servers/thin.yml", File.read("spec/files/no_servers.yml")
  
  chdir {
    Exit_0 "cd Hi/config    && bundle exec thin config -C thin.yml --port 3010 --servers 2"
    Exit_0 "cd Hello/config && bundle exec thin config -C thin.yml --port 4010 --servers 3"
    
    Exit_0 "cd Hi/custom    && bundle exec thin config -C my.yml --port 6010 --servers 4"
    Exit_0 "cd Hello/custom && bundle exec thin config -C my.yml --port 7010 --servers 5"
  }
end

reset_dir 

def reset_file
  chdir { 
    file = "upstreams.conf"
    nginx = "nginx.conf"
    Exit_0 "rm #{file}" if File.exists?(file)
    Exit_0 "rm #{nginx}" if File.exists?(nginx)
  }
end

shared "file_maker" do

  before {
    reset_file
  }

end

# ======== Include the tests.
if ARGV.size > 1 && ARGV[1, ARGV.size - 1].detect { |a| File.exists?(a) }
  # Do nothing. Bacon grabs the file.
else
  Dir.glob('spec/tests/*.rb').each { |file|
    require File.expand_path(file.sub('.rb', '')) if File.file?(file)
  }
end
