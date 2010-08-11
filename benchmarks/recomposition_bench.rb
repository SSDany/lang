require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

TIMES = ARGV[0] ? ARGV[0].to_i : 100_000

RBench.run(TIMES) do

  column :times
  column :one,  :title => 'setters'
  column :two,  :title => 'recompose'
  column :diff, :title => '#2/#1', :compare => [:two, :one]

  report "'ja'" do

    one do
      langtag = Lang::Tag::Langtag.new
      langtag.language = 'ja'
    end

    two do
      langtag = Lang::Tag::Langtag.new
      langtag.recompose('ja')
    end

  end

  report "'ja-Hira'" do

    one do
      langtag = Lang::Tag::Langtag.new
      langtag.language = 'ja'
      langtag.script = 'Hira'
    end

    two do
      langtag = Lang::Tag::Langtag.new
      langtag.recompose('ja-Hira')
    end

  end

  report "'ja-Hira-JP'" do

    one do
      langtag = Lang::Tag::Langtag.new
      langtag.language = 'ja'
      langtag.script = 'Hira'
      langtag.region = 'JP'
    end

    two do
      langtag = Lang::Tag::Langtag.new
      langtag.recompose('ja-Hira-JP')
    end

  end

  report "'ja-Latn-hepburn-heploc'" do

    one do
      langtag = Lang::Tag::Langtag.new
      langtag.language = 'ja'
      langtag.script = 'Latn'
      langtag.variants_sequence = 'hepburn-heploc'
    end

    two do
      langtag = Lang::Tag::Langtag.new
      langtag.recompose('ja-Latn-hepburn-heploc')
    end

  end

  report "'ja-Latn-hepburn-heploc-a-ext1-ext2-b-ext'" do

    one do
      langtag = Lang::Tag::Langtag.new
      langtag.language = 'ja'
      langtag.script = 'Latn'
      langtag.variants_sequence = 'hepburn-heploc'
      langtag.extensions_sequence = 'a-ext1-ext2-b-ext'
    end

    two do
      langtag = Lang::Tag::Langtag.new
      langtag.recompose('ja-Latn-hepburn-heploc-a-ext1-ext2-b-ext')
    end

  end

  report "'ja-Latn-hepburn-heploc-a-ext1-ext2-b-ext-x-private'" do

    one do
      langtag = Lang::Tag::Langtag.new
      langtag.language = 'ja'
      langtag.script = 'Latn'
      langtag.variants_sequence = 'hepburn-heploc'
      langtag.extensions_sequence = 'a-ext1-ext2-b-ext'
      langtag.privateuse_sequence = 'x-private'
    end

    two do
      langtag = Lang::Tag::Langtag.new
      langtag.recompose('ja-Latn-hepburn-heploc-a-ext1-ext2-b-ext-x-private')
    end

  end

end

# EOF