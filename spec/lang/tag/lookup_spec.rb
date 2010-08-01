require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

require 'lang/tag/lookup'

describe Lang::Tag::Lookup, "#lookup_candidates" do

  it "returns 5 candidates for the tag 'zh-Hant-CN-x-private1-private2'" do
    candidates = Lang::Tag::Langtag('zh-Hant-CN-x-private1-private2').lookup_candidates
    candidates.size.should == 5
    candidates[0].should == 'zh-Hant-CN-x-private1-private2'
    candidates[1].should == 'zh-Hant-CN-x-private1'
    candidates[2].should == 'zh-Hant-CN'
    candidates[3].should == 'zh-Hant'
    candidates[4].should == 'zh'
  end

end

describe Lang::Tag::Lookup, "#lookup_candidates", "with the custom min_subtags_count" do

  it "returns nil when min_subtags_count is 0" do
    candidates = Lang::Tag::Langtag('zh-Hant-CN-x-private1-private2').lookup_candidates(0)
    candidates.should be_nil
  end

  it "returns 5 candidates for the tag 'zh-Hant-CN-x-private1-private2" \
     "when min_subtags_count is 1" do
    candidates = Lang::Tag::Langtag('zh-Hant-CN-x-private1-private2').lookup_candidates(1)
    candidates.size.should == 5
    candidates[0].should == 'zh-Hant-CN-x-private1-private2'
    candidates[1].should == 'zh-Hant-CN-x-private1'
    candidates[2].should == 'zh-Hant-CN'
    candidates[3].should == 'zh-Hant'
    candidates[4].should == 'zh'
  end

  it "returns 4 candidates for the tag 'zh-Hant-CN-x-private1-private2" \
     "when min_subtags_count is 2" do
    candidates = Lang::Tag::Langtag('zh-Hant-CN-x-private1-private2').lookup_candidates(2)
    candidates.size.should == 4
    candidates[0].should == 'zh-Hant-CN-x-private1-private2'
    candidates[1].should == 'zh-Hant-CN-x-private1'
    candidates[2].should == 'zh-Hant-CN'
    candidates[3].should == 'zh-Hant'
  end

  it "returns 3 candidates for the tag 'zh-Hant-CN-x-private1-private2" \
     "when min_subtags_count is 3" do
    candidates = Lang::Tag::Langtag('zh-Hant-CN-x-private1-private2').lookup_candidates(3)
    candidates.size.should == 3
    candidates[0].should == 'zh-Hant-CN-x-private1-private2'
    candidates[1].should == 'zh-Hant-CN-x-private1'
    candidates[2].should == 'zh-Hant-CN'
  end

  it "returns 2 candidates for the tag 'zh-Hant-CN-x-private1-private2" \
     "when min_subtags_count is 4" do
    candidates = Lang::Tag::Langtag('zh-Hant-CN-x-private1-private2').lookup_candidates(4)
    candidates.size.should == 2
    candidates[0].should == 'zh-Hant-CN-x-private1-private2'
    candidates[1].should == 'zh-Hant-CN-x-private1'
  end

  it "returns 2 candidates for the tag 'zh-Hant-CN-x-private1-private2" \
     "when min_subtags_count is 5" do
    candidates = Lang::Tag::Langtag('zh-Hant-CN-x-private1-private2').lookup_candidates(5)
    candidates.size.should == 2
    candidates[0].should == 'zh-Hant-CN-x-private1-private2'
    candidates[1].should == 'zh-Hant-CN-x-private1'
  end

  it "returns 1 candidate for the tag 'zh-Hant-CN-x-private1-private2" \
     "when min_subtags_count is 6" do
    candidates = Lang::Tag::Langtag('zh-Hant-CN-x-private1-private2').lookup_candidates(6)
    candidates.size.should == 1
    candidates[0].should == 'zh-Hant-CN-x-private1-private2'
  end

  it "returns nil when the tag is 'zh-Hant-CN-x-private1-private2" \
     "and min_subtags_count is 7" do
    candidates = Lang::Tag::Langtag('zh-Hant-CN-x-private1-private2').lookup_candidates(7)
    candidates.should be_nil
  end

end

# EOF