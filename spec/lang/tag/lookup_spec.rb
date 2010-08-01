require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

require 'lang/tag/lookup'

describe Lang::Tag::Lookup, "#lookup_candidates" do

  it "works" do
    candidates = Lang::Tag::Langtag('zh-Hant-CN-x-private1-private2').lookup_candidates
    candidates.size.should == 5
    candidates[0].should == 'zh-Hant-CN-x-private1-private2'
    candidates[1].should == 'zh-Hant-CN-x-private1'
    candidates[2].should == 'zh-Hant-CN'
    candidates[3].should == 'zh-Hant'
    candidates[4].should == 'zh'
  end

end

# EOF