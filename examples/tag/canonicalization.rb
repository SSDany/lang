require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

require 'lang/tag/canonicalization'

# grandfathered registrations
grandfathered = Lang::Tag::Grandfathered('zh-hakka')

puts grandfathered.to_s #=> "zh-hakka"
puts grandfathered.to_langtag.to_s #=> "hak"

# canonical and extlang forms
langtag = Lang::Tag::Langtag('sgn-jsl')

puts langtag.to_s     #=> "sgn-jsl"
puts langtag.primary  #=> "sng"
puts langtag.extlang  #=> "jsl"

langtag.canonicalize!
puts langtag.to_s     #=> "jsl"
puts langtag.primary  #=> "jsl"
puts langtag.extlang  #=> nil

langtag.to_extlang_form!
puts langtag.to_s     #=> "sgn-jsl"
puts langtag.primary  #=> "sng"
puts langtag.extlang  #=> "jsl"

# variants
langtag = Lang::Tag::Langtag('ja-Latn-hepburn-heploc')

puts langtag.to_s #=> "ja-Latn-hepburn-heploc"
puts langtag.variants #=> ["hepburn", "heploc"]

langtag.canonicalize!
puts langtag.to_s #=> "ja-Latn-hepburn-alalc97"
puts langtag.variants #=> ["hepburn", "alalc97"]

langtag = Lang::Tag::Langtag('ja-Latn-heploc')
puts langtag.to_s #=> "ja-Latn-heploc"
begin
  langtag.canonicalize!
rescue Lang::Tag::Canonicalization::Error => e
  puts e.message
end

# suppress-script
langtag = Lang::Tag::Langtag('ru-Cyrl-RU')
puts Lang::Subtags::Language('ru').suppress_script #=> Cyrl

puts langtag.to_s         #=> "ru-Cyrl-RU"
puts langtag.script.to_s  #=> "Cyrl"

langtag.suppress_script!
puts langtag.to_s         #=> "ru-RU"
puts langtag.script       #=> nil

langtag = Lang::Tag::Langtag('zh-Hant')
puts Lang::Subtags::Language('zh').suppress_script #=> nil

puts langtag.to_s         #=> "zh-Hant"
puts langtag.script.to_s  #=> "Hant"

langtag.suppress_script!
puts langtag.to_s         #=> "zh-Hant"
puts langtag.script       #=> "Hant"

# EOF