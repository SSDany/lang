require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

TIMES = ARGV[0] ? ARGV[0].to_i : 100_000

RBench.run(TIMES) do

  class Lang::Tag::Composition
    alias :original_nicecase! :nicecase! 
  end

  column :times
  column :nope, :title => 'instantiation'
  column :one,  :title => 'Composition#nicecase!'
  column :two,  :title => 'Langtag#nicecase!'

  default do |group, snippet, *requisites|
    group.report(snippet.inspect) do
      nope  { Lang::Tag::Langtag(snippet) }
      one   { Lang::Tag::Langtag(snippet).original_nicecase! }
      two   { Lang::Tag::Langtag(snippet).nicecase! }
    end
  end

  add_reports 'ja-hira', 'ja-hira-jp', 'ja-latn-Hepburn-ALALC97'

end

# EOF