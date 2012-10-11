#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'
require 'yard'

task :default => :test

Rake::TestTask.new do |t|
  t.ruby_opts << '-I test/rss'
  t.test_files = FileList['test/**/test_*.rb']
end
YARD::Rake::YardocTask.new
