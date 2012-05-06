require 'Thin_Upstreams/version'
require "yaml"

def Thin_Upstreams glob = "./*/{config,.}/thin.yml"

  str = %~\n~
  arr = Dir.glob(glob).sort.each { |file|
      o = YAML::load File.read(file)
      app_name = begin
                   pwd  = File.join( File.expand_path("."), "/" )
                   path = File.expand_path(file)
                   path.sub(pwd, '').split("/").first
                 end
      
      ports = Thin_Port_To_Array(o["port"], o["servers"])
      str << %~
        upstream #{app_name} {
          #{ ports.map { |i| "server 127.0.0.1:#{i}" }.join(";
          ") };
        }
      ~
    }

  File.write "upstreams.conf", str
end

def Thin_Port_To_Array raw_port, raw_num
  port = Integer(raw_port)
  q    = Integer(raw_num || 1)
  (0...q).to_a.map { |i| port + i }
end
