require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Lang::Tag::Langtag, "'de-DE'" do

  before :each do
    @langtag = Lang::Tag::Langtag('de-DE')
  end

  it "is equal to the langtag 'de-DE'" do
    @langtag.should == Lang::Tag::Langtag('de-DE')
  end

  it "is not equal to the string 'de-DE'" do
    @langtag.should_not == 'de-DE'
  end

  it "is equal to the langtag 'DE-de'" do
    @langtag.should == Lang::Tag::Langtag('DE-de')
  end

  it "is equal to the langtag 'dE-De'" do
    @langtag.should == Lang::Tag::Langtag('dE-De')
  end

  it "is not equal to the langtag 'de-DE-x-goethe'" do
    @langtag.should_not == Lang::Tag::Langtag('de-DE-x-goethe')
  end

  it "is not equal to the langtag 'De-Latn-DE'" do
    @langtag.should_not == Lang::Tag::Langtag('de-Latn-DE')
  end

  it "is not equal to the langtag 'de'" do
    @langtag.should_not == Lang::Tag::Langtag('de')
  end

  it "is an equivalent of the 'de-DE'" do
    @langtag.should === Lang::Tag::Langtag('DE-de')
    @langtag.should === 'DE-de'
  end

  it "is an equivalent of the 'dE-De'" do
    @langtag.should === Lang::Tag::Langtag('dE-De')
    @langtag.should === 'dE-De'
  end

  it "is not an equivalent of the 'dE-De'" do
    @langtag.should_not === Lang::Tag::Langtag('de-DE-x-goethe')
    @langtag.should_not === 'de-DE-x-goethe'
  end

  it "is not an equivalent of the 'de-DE-x-goethe'" do
    @langtag.should_not === Lang::Tag::Langtag('de-DE-x-goethe')
    @langtag.should_not === 'de-DE-x-goethe'
  end

  it "is not an equivalent of 'de-Latn-DE'" do
    @langtag.should_not === Lang::Tag::Langtag('de-Latn-DE')
    @langtag.should_not === 'de-Latn-DE'
  end

  it "is not an equivalent of the 'de'" do
    @langtag.should_not === Lang::Tag::Langtag('de')
    @langtag.should_not === 'de'
  end

  it "is exactly equal to the langtag 'de-DE'" do
    candidate = Lang::Tag::Langtag('de-DE')
    @langtag.should be_eql candidate
    @langtag.hash.should == candidate.hash
  end

  it "is not exactly equal to the langtag 'dE-De'" do
    candidate = Lang::Tag::Langtag('dE-De')
    @langtag.should_not be_eql candidate
    @langtag.hash.should_not == candidate.hash
  end

  it "is definitely not a 42" do
    @langtag.should_not ==  42
    @langtag.should_not === 42
    @langtag.should_not be_eql 42
  end

end

describe Lang::Tag::Grandfathered, "'zh-hakka'" do

  before :each do
    @grandfathered = Lang::Tag::Grandfathered('zh-hakka')
  end

  it "is equal to the grandfathered language tag 'zh-hakka'" do
    @grandfathered.should == Lang::Tag::Grandfathered('zh-hakka')
  end

  it "is exactly equal to the grandfathered language tag 'zh-hakka'" do
    candidate = Lang::Tag::Grandfathered('zh-hakka')
    @grandfathered.should be_eql candidate
    @grandfathered.hash.should == candidate.hash
  end

  it "is equal to the grandfathered language tag 'zh-Hakka'" do
    @grandfathered.should == Lang::Tag::Grandfathered('zh-Hakka')
  end

  it "is not exactly equal to the grandfathered language tag 'zh-Hakka'" do
    candidate = Lang::Tag::Grandfathered('zh-Hakka')
    @grandfathered.should_not be_eql candidate
    @grandfathered.hash.should_not == candidate.hash
  end

  it "is not equal to the grandfathered language tag 'zh-min-nan'" do
    @grandfathered.should_not == Lang::Tag::Grandfathered('zh-min-nan')
  end

  it "is not equal to the string 'zh-hakka'" do
    @grandfathered.should_not == 'zh-hakka'
  end

  it "is not equal to the langtag 'zh-hakka'" do
    @grandfathered.should_not == Lang::Tag::Langtag('zh-hakka')
  end

  it "is an equivalent of the 'zh-hakka'" do
    @grandfathered.should === 'zh-hakka'
    @grandfathered.should === Lang::Tag::Grandfathered('zh-hakka')
  end

  it "is an equivalent of the 'zh-Hakka'" do
    @grandfathered.should === 'zh-Hakka'
    @grandfathered.should === Lang::Tag::Grandfathered('zh-Hakka')
  end

  it "is an equivalent of the langtag 'zh-hakka'" do
    @grandfathered.should === Lang::Tag::Langtag('zh-hakka')
  end

  it "is not an equivalent of the 'zh-min-nan'" do
    @grandfathered.should_not === Lang::Tag::Grandfathered('zh-min-nan')
    @grandfathered.should_not === 'zh-min-nan'
  end

  it "is definitely not a 42" do
    @grandfathered.should_not ==  42
    @grandfathered.should_not === 42
    @grandfathered.should_not be_eql 42
  end

end

describe Lang::Tag::Privateuse, "'x-attic'" do

  before :each do
    @privateuse = Lang::Tag::Privateuse('x-attic')
  end

  it "is equal to the privateuse language tag 'x-attic'" do
    @privateuse.should == Lang::Tag::Privateuse('x-attic')
  end

  it "is exactly equal to the privateuse language tag 'x-attic'" do
    candidate = Lang::Tag::Privateuse('x-attic')
    @privateuse.should be_eql candidate
    @privateuse.hash.should == candidate.hash
  end

  it "is equal to the privateuse language tag 'x-Attic'" do
    @privateuse.should == Lang::Tag::Privateuse('x-Attic')
  end

  it "is not exactly equal to the privateuse language tag 'x-Attic'" do
    candidate = Lang::Tag::Privateuse('x-Attic')
    @privateuse.should_not be_eql candidate
    @privateuse.hash.should_not == candidate.hash
  end

  it "is not equal to the privateuse language tag 'x-koine'" do
    @privateuse.should_not == Lang::Tag::Privateuse('x-koine')
  end

  it "is not equal to the string 'x-attic'" do
    @privateuse.should_not == 'x-attic'
  end

  it "is an equivalent of the 'x-attic'" do
    @privateuse.should === 'x-attic'
    @privateuse.should === Lang::Tag::Privateuse('x-attic')
  end

  it "is an equivalent of the 'x-Attic'" do
    @privateuse.should === 'x-Attic'
    @privateuse.should === Lang::Tag::Privateuse('x-Attic')
  end

  it "is not an equivalent of the 'x-koine'" do
    @privateuse.should_not === 'x-koine'
    @privateuse.should_not === Lang::Tag::Privateuse('x-koine')
  end

  it "is definitely not a 42" do
    @privateuse.should_not ==  42
    @privateuse.should_not === 42
    @privateuse.should_not be_eql 42
  end

end

describe Lang::Tag::Composition, "#subtags_count" do

  it "considers the tag 'hak' cosisits of the one subtag" do
    Lang::Tag::Langtag('hak').subtags_count.should == 1
  end

  it "considers the tag 'zh-hakka' cosisits of 2 subtag" do
    Lang::Tag::Grandfathered('zh-hakka').subtags_count.should == 2
  end

  it "considers the tag 'x-attic' cosisits of 2 subtags" do
    Lang::Tag::Privateuse('x-attic').subtags_count.should == 2
  end

  it "considers the tag 'de-DE' consists of 2 subtags" do
    Lang::Tag::Langtag('de-DE').subtags_count.should == 2
  end

  it "considers the tag 'de-Latn-DE' consists of 3 subtags" do
    Lang::Tag::Langtag('de-Latn-DE').subtags_count.should == 3
  end

  it "considers the tag 'de-Latn-DE-u-attr-co-phonebk' consists of 7 subtags" do
    Lang::Tag::Langtag('de-Latn-DE-u-attr-co-phonebk').subtags_count.should == 7
  end

  it "considers the tag 'de-Latn-DE-u-attr-co-phonebk-x-private-use' consists of 10 subtags" do
    Lang::Tag::Langtag('de-Latn-DE-u-attr-co-phonebk-x-private-use').subtags_count.should == 10
  end

end

describe Lang::Tag::Composition, "#length" do

  it "considers the tag 'hak' cosisits of 3 chars" do
    Lang::Tag::Langtag('hak').length.should == 3
  end

  it "considers the tag 'zh-hakka' cosisits of 8 chars" do
    Lang::Tag::Grandfathered('zh-hakka').length.should == 8
  end

  it "considers the tag 'x-attic' cosisits of 7 chars" do
    Lang::Tag::Privateuse('x-attic').length.should == 7
  end

  it "considers the tag 'de-DE' consists of 5 chars" do
    Lang::Tag::Langtag('de-DE').length.should == 5
  end

  it "considers the tag 'de-Latn-DE' consists of 10 chars" do
    Lang::Tag::Langtag('de-Latn-DE').length.should == 10
  end

  it "considers the tag 'de-Latn-DE-u-attr-co-phonebk' consists of 28 chars" do
    Lang::Tag::Langtag('de-Latn-DE-u-attr-co-phonebk').length.should == 28
  end

  it "considers the tag 'de-Latn-DE-u-attr-co-phonebk-x-private-use' consists of 42 chars" do
    Lang::Tag::Langtag('de-Latn-DE-u-attr-co-phonebk-x-private-use').length.should == 42
  end

end

# EOF