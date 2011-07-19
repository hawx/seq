# -*- encoding: utf-8 -*-
require File.expand_path("../lib/seq/version", __FILE__)

Gem::Specification.new do |s|
  s.name         = "seq"
  s.author       = "Joshua Hawxwell"
  s.email        = "m@hawx.me"
  s.summary      = "A short summary of what it does."
  s.homepage     = "http://github.com/hawx/seq"
  s.version      = Seq::VERSION
  
  s.description  = <<-DESC
    A long form description. Nicely indented and wrapped at ~70 chars.
    Here's a measuring line for you. (Don't keep this in when releasing.)
    ----------------------------------------------------------------------
  DESC
  
  s.files        = %w(README.md Rakefile LICENSE)
  s.files       += Dir["{lib,test}/**/*"] & `git ls-files`.split("\n")
  s.test_files   = Dir["{test}/**/*"] & `git ls-files`.split("\n")
end
