# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "weathervision/version"

Gem::Specification.new do |s|
  s.name        = "weathervision"
  s.version     = Weathervision::VERSION
  s.authors     = ["Bas Brugman"]
  s.email       = ["bas.brugman@visionnaire.nl"]
  s.homepage    = "http://www.visionnaire.nl"
  s.summary     = %q{Weather gem for conky}
  s.description = %q{Weathervision is a weather forecast Ruby gem to be used with the light-weight system monitor Conky for X.}
  s.licenses    = ['MIT']

  s.rubyforge_project = "weathervision"

  s.add_dependency "httparty"
  s.add_dependency "thor"
  s.add_dependency "json"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "debugger"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-debugger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
