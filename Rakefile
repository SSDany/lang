require 'pathname'
require 'rubygems'
require 'bundler/setup'

ROOT = Pathname(__FILE__).dirname.expand_path
require ROOT + 'lib/lang/version'

require ROOT + 'tasks/spec'
require ROOT + 'tasks/doc'
require ROOT + 'tasks/benchmarks'
require ROOT + 'tasks/package'

task :default => :spec

# EOF