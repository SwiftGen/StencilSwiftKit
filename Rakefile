#!/usr/bin/rake

require 'English'

unless defined?(Bundler)
  puts 'Please use bundle exec to run the rake command'
  exit 1
end

## [ Constants ] ##############################################################

POD_NAME = 'StencilSwiftKit'.freeze
MIN_XCODE_VERSION = 13.0
BUILD_DIR = File.absolute_path('./.build')

task :default => 'spm:test'
