# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "littlebrat"
  s.version     = '0.1.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Mike Moore']
  s.email       = ['mike@blowmage.com']
  s.homepage    = "http://rubygems.org/gems/littlebrat"
  s.summary     = "A handy little app to entertain the kiddos"
  s.description = "Because kids like to smash buttons"

  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency(%q<gosu>, ["~> 0.7.24"])
  s.rubyforge_project         = "littlebrat"

  s.files        = Dir.glob 'lib/**/*.rb'
  s.executables  = ['littlebrat']
  s.require_path = 'lib'
end