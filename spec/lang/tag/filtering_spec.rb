require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

require 'lang/tag/filtering'

describe "language-tag 'de-DE-1996-a-xxx-b-yyy-x-private'" do

  before :each do
    @langtag = Lang::Tag::Langtag('de-DE-1996-a-xxx-b-yyy-x-private')
  end

  it "is matched by the basic language-range 'de-DE-1996-a-xxx-b-yyy'" do
    @langtag.should have_prefix(Lang::Tag::Langtag('de-DE-1996-a-xxx-b-yyy'))
    @langtag.should have_prefix('de-DE-1996-a-xxx-b-yyy')
  end

  it "is matched by the basic language-range 'de-DE-1996-a-xxx'" do
    @langtag.should have_prefix(Lang::Tag::Langtag('de-DE-1996-a-xxx'))
    @langtag.should have_prefix('de-DE-1996-a-xxx')
  end

  it "is matched by the basic language-range 'de-DE-1996'" do
    @langtag.should have_prefix(Lang::Tag::Langtag('de-DE-1996'))
    @langtag.should have_prefix('de-DE-1996')
  end

  it "is matched by the basic language-range 'de-DE'" do
    @langtag.should have_prefix(Lang::Tag::Langtag('de-DE'))
    @langtag.should have_prefix('de-DE')
  end

  it "is matched by the basic language-range 'de'" do
    @langtag.should have_prefix(Lang::Tag::Langtag('de'))
    @langtag.should have_prefix('de')
  end

  it "is not matched by the basic language-range 'de-Latn-DE'" do
    @langtag.should_not have_prefix(Lang::Tag::Langtag('de-Latn-DE'))
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

describe "language-tag 'zh-min-nan'" do

  before :each do
    @grandfathered = Lang::Tag::Grandfathered('zh-min-nan')
  end

  it "is matched by the basic language-range 'zh-min-nan'" do
    @grandfathered.should have_prefix(Lang::Tag::Grandfathered('zh-min-nan'))
    @grandfathered.should have_prefix('zh-min-nan')
  end

  it "is matched by the basic language-range 'zh-min'" do
    @grandfathered.should have_prefix(Lang::Tag::Langtag('zh-min'))
    @grandfathered.should have_prefix('zh-min')
  end

  it "is matched by the basic language-range 'zh'" do
    @grandfathered.should have_prefix(Lang::Tag::Langtag('zh'))
    @grandfathered.should have_prefix('zh')
  end

  it "is not matched by the basic language-range 'zh-hakka'" do
    @grandfathered.should_not have_prefix(Lang::Tag::Grandfathered('zh-hakka'))
    @grandfathered.should_not have_prefix(Lang::Tag::Langtag('zh-hakka'))
    @grandfathered.should_not have_prefix('zh-hakka')
  end

  it "is not matched by the 'zh-'" \
    "which is not a language-range at all" do
    @grandfathered.should_not have_prefix('zh-')
  end

  it "is not matched by the '42', " \
     "which is not a language-range at all" do
    @grandfathered.should_not have_prefix(42)
  end

end

describe "language-tag 'x-private-attic'" do

  before :each do
    @privateuse = Lang::Tag::Privateuse('x-private-attic')
  end

  it "is matched by the basic language-range 'x-private-attic'" do
    @privateuse.should have_prefix(Lang::Tag::Privateuse('x-private-attic'))
    @privateuse.should have_prefix('x-private-attic')
  end

  it "is matched by the basic language-range 'x-private'" do
    @privateuse.should have_prefix(Lang::Tag::Privateuse('x-private'))
    @privateuse.should have_prefix('x-private')
  end

  it "is matched by the basic language-range 'x'" do
    @privateuse.should have_prefix('x')
  end

  it "is not matched by the basic language-range 'x-attic'" do
    @privateuse.should_not have_prefix(Lang::Tag::Privateuse('x-attic'))
    @privateuse.should_not have_prefix('x-attic')
  end

  it "is not matched by the 'x-'" \
    "which is not a language-range at all" do
    @privateuse.should_not have_prefix('x-')
  end

  it "is not matched by the '42', " \
     "which is not a language-range at all" do
    @privateuse.should_not have_prefix(42)
  end

end

describe "extended language-range 'de-*-DE' (synonym of 'de-DE')" do

  it "matches the language-tag 'de-DE'" do
    Lang::Tag::Langtag('de-DE').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag::Langtag('de-DE').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-de'" do
    Lang::Tag::Langtag('de-de').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag::Langtag('de-de').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-Latn-DE'" do
    Lang::Tag::Langtag('de-Latn-DE').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag::Langtag('de-Latn-DE').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-Latf-DE'" do
    Lang::Tag::Langtag('de-Latf-DE').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag::Langtag('de-Latf-DE').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-DE-x-goethe'" do
    Lang::Tag::Langtag('de-DE-x-goethe').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag::Langtag('de-DE-x-goethe').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-Latn-DE-1996'" do
    Lang::Tag::Langtag('de-Latn-DE-1996').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag::Langtag('de-Latn-DE-1996').should be_matched_by_extended_range('de-DE')
  end

  it "matches the language-tag 'de-Deva-DE'" do
    Lang::Tag::Langtag('de-Deva-DE').should be_matched_by_extended_range('de-*-DE')
    Lang::Tag::Langtag('de-Deva-DE').should be_matched_by_extended_range('de-DE')
  end

  it "does not match the language-tag 'de'" do
    Lang::Tag::Langtag('de').should_not be_matched_by_extended_range('de-*-DE')
    Lang::Tag::Langtag('de').should_not be_matched_by_extended_range('de-DE')
  end

  it "does not match the language-tag 'de-x-DE'" do
    Lang::Tag::Langtag('de-x-DE').should_not be_matched_by_extended_range('de-*-DE')
    Lang::Tag::Langtag('de-x-DE').should_not be_matched_by_extended_range('de-DE')
  end

  it "does not match the language-tag 'de-Deva'" do
    Lang::Tag::Langtag('de-Deva').should_not be_matched_by_extended_range('de-*-DE')
    Lang::Tag::Langtag('de-Deva').should_not be_matched_by_extended_range('de-DE')
  end

end

describe "extended language-range 'i-*'" do

  it "matches the language-tag 'i-default'" do
    Lang::Tag::Grandfathered('i-default').should be_matched_by_extended_range('i-*')
    Lang::Tag::Grandfathered('i-default').should be_matched_by_extended_range('i')
  end

  it "matches the language-tag 'i-Default'" do
    Lang::Tag::Grandfathered('i-Default').should be_matched_by_extended_range('i-*')
    Lang::Tag::Grandfathered('i-Default').should be_matched_by_extended_range('i')
  end

  it "does not match the language-tag 'zh-hakka'" do
    Lang::Tag::Grandfathered('zh-hakka').should_not be_matched_by_extended_range('i-*')
    Lang::Tag::Grandfathered('zh-hakka').should_not be_matched_by_extended_range('i')
  end

  it "does not match the language-tag 'yue'" do
    Lang::Tag::Langtag('yue').should_not be_matched_by_extended_range('i-*')
    Lang::Tag::Langtag('yue').should_not be_matched_by_extended_range('i')
  end

end

describe "extended language-range 'x-*-attic' (synonym of the 'x-attic')" do

  it "matches the language-tag 'x-attic'" do
    Lang::Tag::Privateuse('x-attic').should be_matched_by_extended_range(Lang::Tag::Privateuse('x-attic'))
    Lang::Tag::Privateuse('x-attic').should be_matched_by_extended_range('x-attic')
  end

  it "matches the language-tag 'x-Attic'" do
    Lang::Tag::Privateuse('x-Attic').should be_matched_by_extended_range(Lang::Tag::Privateuse('x-attic'))
    Lang::Tag::Privateuse('x-Attic').should be_matched_by_extended_range('x-attic')
  end

  it "matches the language-tag 'el-x-attic'" do
    Lang::Tag::Langtag('el-x-attic').should be_matched_by_extended_range(Lang::Tag::Privateuse('x-attic'))
    Lang::Tag::Langtag('el-x-attic').should be_matched_by_extended_range('x-attic')
  end

  it "matches the language-tag 'x-private-attic'" do
    Lang::Tag::Privateuse('x-private-attic').should be_matched_by_extended_range(Lang::Tag::Privateuse('x-attic'))
    Lang::Tag::Privateuse('x-private-attic').should be_matched_by_extended_range('x-attic')
  end

  it "does not match the language-tag 'x-koine'" do
    Lang::Tag::Privateuse('x-koine').should_not be_matched_by_extended_range(Lang::Tag::Privateuse('x-attic'))
    Lang::Tag::Privateuse('x-koine').should_not be_matched_by_extended_range('x-attic')
  end

  it "does not match the language-tag 'el-x-koine'" do
    Lang::Tag::Langtag('el-x-koine').should_not be_matched_by_extended_range(Lang::Tag::Privateuse('x-attic'))
    Lang::Tag::Langtag('el-x-koine').should_not be_matched_by_extended_range('x-attic')
  end

end

describe "wildcard" do

  it "matches the language-tag 'x-attic'" do
    Lang::Tag::Privateuse('x-attic').should be_matched_by_extended_range('*')
    Lang::Tag::Privateuse('x-attic').should be_matched_by_basic_range('*')
  end

  it "matches the language-tag 'zh-hakka'" do
    Lang::Tag::Grandfathered('zh-hakka').should be_matched_by_extended_range('*')
    Lang::Tag::Grandfathered('zh-hakka').should be_matched_by_basic_range('*')
  end

  it "matches the language-tag 'de'" do
    Lang::Tag::Langtag('de').should be_matched_by_extended_range('*')
    Lang::Tag::Langtag('de').should be_matched_by_basic_range('*')
  end

  it "matches the language-tag 'de-DE'" do
    Lang::Tag::Langtag('de-DE').should be_matched_by_extended_range('*')
    Lang::Tag::Langtag('de-DE').should be_matched_by_basic_range('*')
  end

  it "matches the language-tag 'de-Latn-DE'" do
    Lang::Tag::Langtag('de-Latn-DE').should be_matched_by_extended_range('*')
    Lang::Tag::Langtag('de-Latn-DE').should be_matched_by_basic_range('*')
  end

  it "matches the language-tag 'de-DE-x-goethe'" do
    Lang::Tag::Langtag('de-DE-x-goethe').should be_matched_by_extended_range('*')
    Lang::Tag::Langtag('de-DE-x-goethe').should be_matched_by_basic_range('*')
  end

end

describe "42" do

  it "does not match the language-tag 'de'" do
    Lang::Tag::Langtag('de').should_not be_matched_by_extended_range(42)
  end

  it "does not match the language-tag 'de-DE'" do
    Lang::Tag::Langtag('de-DE').should_not be_matched_by_extended_range(42)
  end

  it "does not match the language-tag 'zh-hakka'" do
    Lang::Tag::Grandfathered('zh-hakka').should_not be_matched_by_extended_range(42)
  end

  it "does not match the language-tag 'x-attic'" do
    Lang::Tag::Privateuse('x-attic').should_not be_matched_by_extended_range(42)
  end

end

# EOF