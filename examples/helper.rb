dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(dir) unless $:.include?(dir)

require 'lang/tag'

# EOF