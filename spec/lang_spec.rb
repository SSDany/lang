require File.expand_path File.join(File.dirname(__FILE__), 'spec_helper')

describe Lang, ".Tag" do

  it "returns the argument passed, if it is a Lang::Tag::Langtag" do
    @tag = Lang::Tag::Langtag.new('de-DE')
    Lang::Tag(@tag).should be_equal @tag
  end

  it "returns the argument passed, if it is a Lang::Tag::Grandfathered" do
    @tag = Lang::Tag::Grandfathered.new('zh-hakka')
    Lang::Tag(@tag).should be_equal @tag
  end

  it "returns the argument passed, if it is a Lang::Tag::Privateuse" do
    @tag = Lang::Tag::Privateuse.new('x-attic')
    Lang::Tag(@tag).should be_equal @tag
  end

end

# EOF