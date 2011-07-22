# -*- encoding: utf-8 -*-
require File.expand_path("../lib/seq/version", __FILE__)

Gem::Specification.new do |s|
  s.name         = "seq"
  s.author       = "Joshua Hawxwell"
  s.email        = "m@hawx.me"
  s.summary      = "Seqs cycle over elements of an array."
  s.homepage     = "http://github.com/hawx/seq"
  s.version      = Seq::VERSION
  
  s.description  = <<-DESC
    A Seq is created with an array, and optionally a number of elements
    to return, an offset to start at and a default item to return when
    ended. Call #next to return the next item.
    
    A Seq::Random will return randomly selected elements from the array.
    A Seq::Lazy will lazily evaluate a block to get the next element.
  DESC
  
  s.files        = %w(README.md Rakefile LICENCE)
  s.files       += Dir["{lib,test}/**/*"] & `git ls-files`.split("\n")
  s.test_files   = Dir["{test}/**/*"] & `git ls-files`.split("\n")
  
  s.add_development_dependency 'minitest', '~> 2.3.1'
end
