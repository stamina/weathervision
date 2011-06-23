# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "weathervision/version"

Gem::Specification.new do |s|
  s.name        = "weathervision"
  s.version     = Weathervision::VERSION
  s.authors     = ["stamina"]
  s.email       = ["bas.brugman@visionnaire.nl"]
  s.homepage    = "http://"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "weathervision"

  s.add_dependency "nokogiri"

  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
