require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Lang::Tag, ".Grandfathered" do

  it "does not allow to create non-grandfathered tags" do
    lambda { Lang::Tag::Grandfathered('non-grandfathered') }.
    should raise_error ArgumentError, %r{is not a grandfathered Language-Tag}
  end

end

describe Lang::Tag::Grandfathered, "'zh-hakka'" do

  it "could be represented as a string 'zh-hakka'" do
    Lang::Tag::Grandfathered('zh-hakka').to_s.should == 'zh-hakka'
  end

  it "could be represented as an array ['zh', 'hakka']" do
    Lang::Tag::Grandfathered('zh-hakka').to_a.should == %w(zh hakka)
  end

end

describe Lang::Tag::Grandfathered, "#nicecase" do
  it "not yet implemented" do
    pending { Lang::Tag::Grandfathered('zh-hakka').nicecase }
  end
end

describe Lang::Tag::Grandfathered, "#nicecase!" do
  it "not yet implemented" do
    pending { Lang::Tag::Grandfathered('zh-hakka').nicecase! }
  end
end

describe Lang::Tag::Grandfathered, "#to_langtag" do
  it "not yet implemented" do
    pending { Lang::Tag::Grandfathered('zh-hakka').to_langtag }
  end
end

# EOF