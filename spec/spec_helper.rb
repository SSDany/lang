require 'pathname'
require 'rubygems'

begin

  gem 'rspec', '>=1.2'
  require 'spec'

  SPEC_ROOT = Pathname(__FILE__).dirname.expand_path

  dir = SPEC_ROOT.parent.join('lib').to_s
  $:.unshift(dir) unless $:.include?(dir)
  require 'lang/subtags'
  require 'lang/tag'

rescue LoadError
end

# EOF