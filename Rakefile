require 'pathname'
require 'rubygems'
require 'rake'

ROOT = Pathname(__FILE__).dirname.expand_path
require ROOT + 'lib/lang/version'

require ROOT + 'tasks/spec'
require ROOT + 'tasks/doc'
require ROOT + 'tasks/benchmarks'

task :default => :spec

# EOF