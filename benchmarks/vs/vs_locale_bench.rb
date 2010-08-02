require File.expand_path(File.join(File.dirname(__FILE__), '..', 'helper'))

TIMES = ARGV[0] ? ARGV[0].to_i : 10_000

RBench.run(TIMES) do

  column :times
  column :one,  :title => 'locale'
  column :two,  :title => 'lang/tag'
  column :diff, :title => '#2/#1', :compare => [:two, :one]

  add_reports = lambda do |group, *snippets|
    snippets.each do |snippet|
      group.report(snippet.inspect) do
        one { Locale::Tag::Rfc._unmemoized_parse(snippet) }
        two { Lang::Tag::Langtag(snippet)  }
      end
      group.summary("")
    end
  end

  # Locale::Tag::Rfc does not support extlangs
  # Locale::Tag::Rfc._unmemoized_parse('zh-yue') #=> nil

  group "language" do
    add_reports[self, "de", "ojp", "otm"]
  end

  group "with script" do
    add_reports[self, "de-Latn", "de-Deva", "ja-Hira", "ja-Hrkt"]
  end

  group "with region" do
    add_reports[self, "de-DE", "zh-HK", "zh-Hans-CN", "qaa-001"]
  end

  group "with variants" do
    add_reports[self, "sl-rozaj", "sl-rozaj-nedis", "sl-rozaj-biske-1994"]
  end

  group "with extensions" do
    add_reports[self, "de-a-xxx", "de-a-xxx-b-yyy", "de-b-yyy-zzz", "de-a-xxx-b-yyy-zzz"]
  end

  group "with privateuse" do
    add_reports[self, "el-x-attic", "el-x-another-private-sequence"]
  end

  summary("")
end

# EOF