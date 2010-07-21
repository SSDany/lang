require File.expand_path File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Lang::Tag, ".wellformed?" do

  describe "[www.langtag.net suite]" do
    extend Suite

    suite('www.langtag.net/well-formed-tags.txt') do |snippet,_|
      it "considers the language-tag '#{snippet}' well-formed" do
        Lang::Tag.wellformed?(snippet).should be_true
      end
    end

    suite('www.langtag.net/broken-tags.txt') do |snippet,_|
      it "considers the language-tag '#{snippet}' ill-formed" do
        Lang::Tag.wellformed?(snippet).should be_false
      end
    end

  end
end

describe Lang::Tag, ".grandfathered?" do

  describe "[ICU suite]" do
    extend Suite

    suite('ICU/grandfathered.txt') do |snippet,_|
      it "considers the language-tag '#{snippet}' grandfathered" do
        Lang::Tag.wellformed?(snippet).should be_true
      end
    end

  end

  it "considers the language-tag 'I-Enochian' grandfathered (case-insensitivity)" do
    Lang::Tag.grandfathered?('I-Enochian').should be_true
  end

  it "considers the language-tag 'i-notexist' not grandfathered" do
    Lang::Tag.grandfathered?('i-bogus').should be_false
  end

  it "considers the language-tag 'en-GB' not grandfathered" do
    Lang::Tag.privateuse?('en-GB').should be_false
  end

  it "considers the language-tag 'i-boooooooooogus' not grandfathered" do
    Lang::Tag.privateuse?('i-boooooooooogus').should be_false
  end

  it "considers the language-tag 'i' not grandfathered" do
    Lang::Tag.privateuse?('i').should be_false
  end

  it "considers the language-tag 'i-' not grandfathered" do
    Lang::Tag.privateuse?('i-').should be_false
  end

  it "considers the language-tag 'i-@@' not grandfathered" do
    Lang::Tag.privateuse?('i-@@').should be_false
  end

end

describe Lang::Tag, ".privateuse?" do

  it "considers the language-tag 'X-private' privateuse" do
    Lang::Tag.privateuse?('X-private').should be_true
  end

  it "considers the language-tag 'x-private' privateuse" do
    Lang::Tag.privateuse?('x-private').should be_true
  end

  it "considers the language-tag 'en-GB' not privateuse" do
    Lang::Tag.privateuse?('en-GB').should be_false
  end

  it "considers the language-tag 'x-boooooooooogus' not privateuse" do
    Lang::Tag.privateuse?('x-toolongtobewellformed').should be_false
  end

  it "considers the language-tag 'x' not privateuse" do
    Lang::Tag.privateuse?('x').should be_false
  end

  it "considers the language-tag 'x-' not privateuse" do
    Lang::Tag.privateuse?('x-@@').should be_false
  end

end

describe Lang, ".Langtag" do

  it "returns the argument passed, if it is already a Lang::Tag::Langtag" do
    @tag = Lang::Tag::Langtag.new('de-DE')
    Lang::Tag::Langtag(@tag).should be_equal @tag
  end

  it "attempts to create a new Lang::Tag::Langtag object otherwise" do
    @tag = Lang::Tag::Langtag.new('de-DE')
    Lang::Tag::Langtag.should_receive(:new).with('de-DE').and_return @tag
    Lang::Tag::Langtag('de-DE').should == @tag
  end

end

describe Lang::Tag, ".Grandfathered" do

  it "returns the argument passed, if it is already a Lang::Tag::Grandfathered" do
    @tag = Lang::Tag::Grandfathered.new('zh-hakka')
    Lang::Tag::Grandfathered(@tag).should be_equal @tag
  end

  it "attempts to create a new Lang::Tag::Grandfathered object otherwise" do
    @tag = Lang::Tag::Grandfathered.new('zh-hakka')
    Lang::Tag::Grandfathered.should_receive(:new).with('zh-hakka').and_return @tag
    Lang::Tag::Grandfathered('zh-hakka').should == @tag
  end

end

describe Lang::Tag, ".Privateuse" do

  it "returns the argument passed, if it is already a Lang::Tag::Privateuse" do
    @tag = Lang::Tag::Privateuse.new('x-attic')
    Lang::Tag::Privateuse(@tag).should be_equal @tag
  end

  it "attempts to create a new Lang::Tag::Privateuse object otherwise" do
    @tag = Lang::Tag::Privateuse.new('x-attic')
    Lang::Tag::Privateuse.should_receive(:new).with('x-attic').and_return @tag
    Lang::Tag::Privateuse('x-attic').should == @tag
  end

end

# EOF