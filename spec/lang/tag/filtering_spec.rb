require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe "language-tag 'de-DE-1996-a-xxx-b-yyy-x-private'" do

  before :each do
    @langtag = Lang::Tag('de-DE-1996-a-xxx-b-yyy-x-private')
  end

  it "is matched by the basic language-range 'de-DE-1996-a-xxx-b-yyy'" do
    @langtag.should have_prefix(Lang::Tag('de-DE-1996-a-xxx-b-yyy'))
    @langtag.should have_prefix('de-DE-1996-a-xxx-b-yyy')
  end

  it "is matched by the basic language-range 'de-DE-1996-a-xxx'" do
    @langtag.should have_prefix(Lang::Tag('de-DE-1996-a-xxx'))
    @langtag.should have_prefix('de-DE-1996-a-xxx')
  end

  it "is matched by the basic language-range 'de-DE-1996'" do
    @langtag.should have_prefix(Lang::Tag('de-DE-1996'))
    @langtag.should have_prefix('de-DE-1996')
  end

  it "is matched by the basic language-range 'de-DE'" do
    @langtag.should have_prefix(Lang::Tag('de-DE'))
    @langtag.should have_prefix('de-DE')
  end

  it "is matched by the basic language-range 'de'" do
    @langtag.should have_prefix(Lang::Tag('de'))
    @langtag.should have_prefix('de')
  end

  it "is not matched by the basic language-range 'de-Latn-DE'" do
    @langtag.should_not have_prefix(Lang::Tag('de-Latn-DE'))
    @langtag.should_not have_prefix('de-Latn-DE')
  end

  it "is not matched by the basic language-range 'de-x', " \
     "which is ill-formed in terms of language-tags" do
    @langtag.should_not have_prefix('de-x')
  end

  it "is not matched by the '42', " \
     "which is not a language-range at all" do
    @langtag.should_not have_prefix(42)
  end

end

describe "extended language-range 'de-*-DE' (synonym of 'de-DE')" do

  it "matches the language-tag 'de-DE'" do
    Lang::Tag('de-DE').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag('de-DE').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-de'" do
    Lang::Tag('de-de').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag('de-de').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-Latn-DE'" do
    Lang::Tag('de-Latn-DE').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag('de-Latn-DE').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-Latf-DE'" do
    Lang::Tag('de-Latf-DE').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag('de-Latf-DE').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-DE-x-goethe'" do
    Lang::Tag('de-DE-x-goethe').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag('de-DE-x-goethe').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-Latn-DE-1996'" do
    Lang::Tag('de-Latn-DE-1996').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag('de-Latn-DE-1996').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-Deva-DE'" do
    Lang::Tag('de-Deva-DE').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag('de-Deva-DE').should be_matched_by_extended_range('de-DE')
  end

  it "does not match the language-tag 'de'" do
    Lang::Tag('de').should_not be_matched_by_extended_range('de-*-DE')
    Lang::Tag('de').should_not be_matched_by_extended_range('de-DE')
  end

  it "does not match the language-tag 'de-x-DE'" do
    Lang::Tag('de-x-DE').should_not be_matched_by_extended_range('de-*-DE')
    Lang::Tag('de-x-DE').should_not be_matched_by_extended_range('de-DE')
  end

  it "does not match the language-tag 'de-Deva'" do
    Lang::Tag('de-Deva').should_not be_matched_by_extended_range('de-*-DE')
    Lang::Tag('de-Deva').should_not be_matched_by_extended_range('de-DE')
  end

end

describe "wildcard" do

  it "matches the language-tag 'de'" do
    Lang::Tag('de').should be_matched_by_extended_range('*')
    Lang::Tag('de').should be_matched_by_basic_range('*')
  end

  it "matches the language-tag 'de-DE'" do
    Lang::Tag('de-DE').should be_matched_by_extended_range('*')
    Lang::Tag('de-DE').should be_matched_by_basic_range('*')
  end

  it "matches the language-tag 'de-Latn-DE'" do
    Lang::Tag('de-Latn-DE').should be_matched_by_extended_range('*')
    Lang::Tag('de-Latn-DE').should be_matched_by_basic_range('*')
  end

  it "matches the language-tag 'de-DE-x-goethe'" do
    Lang::Tag('de-DE-x-goethe').should be_matched_by_extended_range('*')
    Lang::Tag('de-DE-x-goethe').should be_matched_by_basic_range('*')
  end

end

# EOF