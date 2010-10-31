require 'rubygems'
require 'bundler'
Bundler.require(:default, :benchmarks)

dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(dir) unless $:.include?(dir)
require 'lang/tag'

require File.expand_path(File.join(File.dirname(__FILE__), 'reporter.rb'))

# EOF