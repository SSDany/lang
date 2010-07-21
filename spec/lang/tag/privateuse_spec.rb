require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Lang::Tag, ".Privateuse" do

  it "does not allow to create non-privateuse tags" do
    lambda { Lang::Tag::Privateuse('non-privateuse') }.
    should raise_error ArgumentError, %r{is not a privateuse Language-Tag}
  end

end

describe Lang::Tag::Privateuse, "'x-attic'" do

  it "could be represented as a string 'x-attic'" do
    Lang::Tag::Privateuse('x-attic').to_s.should == 'x-attic'
  end

  it "could be represented as an array ['x', 'attic']" do
    Lang::Tag::Privateuse('x-attic').to_a.should == %w(x attic)
  end

end

describe Lang::Tag::Privateuse, "#nicecase" do

  it "transforms 'x-attic' to 'x-attic'" do
    Lang::Tag::Privateuse('x-attic').nicecase.should == Lang::Tag::Privateuse('x-attic')
  end

  it "transforms 'X-Attic' to 'x-attic'" do
    Lang::Tag::Privateuse('X-Attic').nicecase.should == Lang::Tag::Privateuse('x-attic')
  end

end

# EOF