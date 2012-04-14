
require File.expand_path('spec/helper')
require 'Thin_Upstreams'
require 'Bacon_Colored'
require 'pry'
require 'Exit_Zero'

DIR = "/tmp/Thin_Upstreams"

def reset_dir
  Exit_Zero "rm -rf #{DIR}"
  
  Exit_Zero "mkdir -p #{DIR}/Hi/config"
  Exit_Zero "mkdir -p #{DIR}/Hi/custom"
  
  Exit_Zero "mkdir -p #{DIR}/Hello/config"
  Exit_Zero "mkdir -p #{DIR}/Hello/custom"
  
  chdir {
    Exit_Zero "cd Hi/config    && bundle exec thin config -C thin.yml --port 3010 --servers 2"
    Exit_Zero "cd Hello/config && bundle exec thin config -C thin.yml --port 4010 --servers 3"
    
    Exit_Zero "cd Hi/custom    && bundle exec thin config -C my.yml --port 6010 --servers 4"
    Exit_Zero "cd Hello/custom && bundle exec thin config -C my.yml --port 7010 --servers 5"
  }
end

def reset_file
  chdir { 
    file = "upstreams.conf"
    Exit_Zero "rm #{file}" if File.exists?(file)
  }
end

def chdir
  Dir.chdir(DIR) {
    yield
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
