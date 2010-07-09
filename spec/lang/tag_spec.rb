require File.expand_path File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Lang::Tag, "'de-DE'" do

  before :each do
    @langtag = Lang::Tag('de-DE')
  end

  it "is equal to the langtag 'de-DE'" do
    @langtag.should == Lang::Tag('de-DE')
  end

  it "is not equal to the string 'de-DE'" do
    @langtag.should_not == 'de-DE'
  end

  it "is equal to the langtag 'DE-de'" do
    @langtag.should == Lang::Tag('DE-de')
  end

  it "is equal to the langtag 'dE-De'" do
    @langtag.should == Lang::Tag('dE-De')
  end

  it "is not equal to the langtag 'de-DE-x-goethe'" do
    @langtag.should_not == Lang::Tag('de-DE-x-goethe')
  end

  it "is not equal to the langtag 'De-Latn-DE'" do
    @langtag.should_not == Lang::Tag('de-Latn-DE')
  end

  it "is not equal to the langtag 'de'" do
    @langtag.should_not == Lang::Tag('de')
  end

  it "is an equivalent of the 'de-DE'" do
    @langtag.should === Lang::Tag('DE-de')
    @langtag.should === 'DE-de'
  end

  it "is an equivalent of the 'dE-De'" do
    @langtag.should === Lang::Tag('dE-De')
    @langtag.should === 'dE-De'
  end

  it "is not an equivalent of the 'dE-De'" do
    @langtag.should_not === Lang::Tag('de-DE-x-goethe')
    @langtag.should_not === 'de-DE-x-goethe'
  end

  it "is not an equivalent of the 'de-DE-x-goethe'" do
    @langtag.should_not === Lang::Tag('de-DE-x-goethe')
    @langtag.should_not === 'de-DE-x-goethe'
  end

  it "is not an equivalent of 'de-Latn-DE'" do
    @langtag.should_not === Lang::Tag('de-Latn-DE')
    @langtag.should_not === 'de-Latn-DE'
  end

  it "is not an equivalent of the 'de'" do
    @langtag.should_not === Lang::Tag('de')
    @langtag.should_not === 'de'
  end

  it "is exactly equal to the langtag 'de-DE'" do
    @langtag.should be_eql Lang::Tag('de-DE')
  end

  it "is not exactly equal to the langtag 'dE-De'" do
    @langtag.should_not be_eql Lang::Tag('dE-De')
  end

  it "is definitely not a 42" do
    @langtag.should_not ==  42
    @langtag.should_not === 42
    @langtag.should_not be_eql 42
  end

end

# EOF