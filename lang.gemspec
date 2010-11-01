Gem::Specification.new do |s|

  s.name = 'lang'
  s.version = '0.1.0'
  s.platform = Gem::Platform::RUBY

  s.authors = %w[SSDany]
  s.email = 'inadsence@gmail.com'
  s.homepage = 'http://github.com/SSDany/lang'
  s.summary = 'Language tags implementation.'
  s.description = <<-DESCR
Language tags implementation.
Features: basic and extended filtering (RFC 4647), canonicalization (using IANA language subtag registry).
DESCR

  s.bindir             = 'bin'
  s.executables        = ['lang']
  s.default_executable = 'lang'

  s.require_path = 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.files = s.extra_rdoc_files + [
    "lib/lang/cli.rb",
    "lib/lang/subtags/entry.rb",
    "lib/lang/subtags/extlang.rb",
    "lib/lang/subtags/grandfathered.rb",
    "lib/lang/subtags/language.rb",
    "lib/lang/subtags/redundant.rb",
    "lib/lang/subtags/region.rb",
    "lib/lang/subtags/script.rb",
    "lib/lang/subtags/variant.rb",
    "lib/lang/subtags.rb",
    "lib/lang/tag/canonicalization.rb",
    "lib/lang/tag/composition.rb",
    "lib/lang/tag/filtering.rb",
    "lib/lang/tag/grandfathered.rb",
    "lib/lang/tag/langtag.rb",
    "lib/lang/tag/lookup.rb",
    "lib/lang/tag/pattern.rb",
    "lib/lang/tag/privateuse.rb",
    "lib/lang/tag.rb",
    "lib/lang/version.rb"
  ]

  s.add_dependency "thor"
  s.add_development_dependency "rspec", ">= 2.0.0"
  s.rubyforge_project = 'lang'
end

# EOF