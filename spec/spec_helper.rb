require 'pathname'
require 'rubygems'

begin

  gem 'rspec', '>=1.2'
  require 'spec'

  SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
  FIXTURES_DIR = SPEC_ROOT.join('fixtures')
  require SPEC_ROOT + 'support/suite'
  require SPEC_ROOT + 'support/memoization_helper'

  dir = SPEC_ROOT.parent.join('lib').to_s
  $:.unshift(dir) unless $:.include?(dir)
  require 'lang/subtags'
  require 'lang/tag'

rescue LoadError
end

# EOF