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

describe Lang::Tag::Grandfathered, "#to_langtag" do
  Lang::Tag::GRANDFATHERED.each do |tag, preferred|

    if preferred
      it "casts '#{tag}' to the Langtag '#{preferred}'" do
        grandfathered = Lang::Tag::Grandfathered(tag)
        candidate = grandfathered.to_langtag
        candidate.should be_eql Lang::Tag::Langtag(preferred)
      end
    else
      it "raises an exception when attempts to cast a '#{tag}' (no preferred value)" do
        grandfathered = Lang::Tag::Grandfathered(tag)
        lambda { grandfathered.to_langtag }.
        should raise_error Lang::Tag::Error, %r{no preferred value}
      end
    end

  end
end

# EOF