# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "weathervision/version"

Gem::Specification.new do |s|
  s.name        = "weathervision"
  s.version     = Weathervision::VERSION
  s.authors     = ["stamina"]
  s.email       = ["bas.brugman@visionnaire.nl"]
  s.homepage    = "http://"
  s.summary     = %q{Write a gem summary}
  s.description = %q{Write a gem description}

  s.rubyforge_project = "weathervision"

  s.add_dependency "thor"
  s.add_dependency "nokogiri"

  s.add_development_dependency "rspec"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-doc"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
