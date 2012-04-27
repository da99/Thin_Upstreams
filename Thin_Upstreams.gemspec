# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "Thin_Upstreams/version"

Gem::Specification.new do |s|
  s.name        = "Thin_Upstreams"
  s.version     = Thin_Upstreams::VERSION
  s.authors     = ["da99"]
  s.email       = ["i-hate-spam-45671204@mailinator.com"]
  s.homepage    = "https://github.com/da99/Thin_Upstreams"
  s.summary     = %q{ Create upstreams conf file for Nginx. }
  s.description = %q{
    A Ruby gem to generate .conf files with upstreams
    to include in your nginx.conf. It uses your
    Thin config files: ./*/thin.yml, ./*/config/thin.yml
  }

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'Exit_0'
  s.add_development_dependency 'bacon'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'Bacon_Colored'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'thin'
  
  # Specify any dependencies here; for example:
  # s.add_runtime_dependency 'rest-client'
end
