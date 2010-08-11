require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

TIMES = ARGV[0] ? ARGV[0].to_i : 100_000

RBench.run(TIMES) do

  column :times
  column :one,  :title => 'langtag'
  column :two,  :title => 'lang/tag'
  column :diff, :title => '#2/#1', :compare => [:two, :one]

  default do |group, snippet, *requisites|
    group.report(snippet.inspect) do
      one { Langtag.new(snippet) }
      two { Lang::Tag::Langtag(snippet) }
    end
  end

  grouped 'language'    , 'de', 'ojp', 'otm', 'zh-yue', 'zh-cmn'
  grouped 'script'      , 'de-Latn', 'de-Deva', 'ja-Hira', 'ja-Hrkt', 'zh-cmn-Hans', 'zh-cmn-Hant'
  grouped 'region'      , 'de-DE', 'zh-HK', 'zh-Hans-CN', 'zh-yue-HK', 'zh-cmn-Hans-CN', 'qaa-001'
  grouped 'variants'    , 'sl-rozaj', 'sl-rozaj-nedis', 'sl-rozaj-biske-1994'
  grouped 'extensions'  , 'de-a-xxx', 'de-a-xxx-b-yyy', 'de-b-yyy-zzz', 'de-a-xxx-b-yyy-zzz'
  grouped 'privateuse'  , 'el-x-attic', 'el-x-another-private-sequence'

  summary ''

end

# EOF