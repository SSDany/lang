require File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

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

# EOF