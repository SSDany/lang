require 'pathname'
require 'rubygems'

require 'bundler'
Bundler.require(:default, :development)

SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
FIXTURES_DIR = SPEC_ROOT.join('fixtures')

dir = SPEC_ROOT.parent.join('lib').to_s
$:.unshift(dir) unless $:.include?(dir)
require 'lang/subtags'
require 'lang/tag'

require SPEC_ROOT + 'support/suite'
require SPEC_ROOT + 'support/registry_helper'

# EOF