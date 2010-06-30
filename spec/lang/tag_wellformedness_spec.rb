require File.expand_path File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Lang::Tag, ".wellformed?" do

  def self.suite(path, &block)
    suite = FIXTURES_DIR.join(path)
    File.open(suite, File::RDONLY).each_line do |snippet|
      snippet,comment = snippet.split("#",2)
      snippet.strip!
      comment.strip! if comment
      yield(snippet,comment) if block_given?
    end
  end

  suite('www.langtag.net/well-formed-tags.txt') do |snippet, comment|
    it "returns true for the #{snippet.inspect} #{"(#{comment})" if comment}" do
      Lang::Tag.wellformed?(snippet).should == true
    end
  end

  suite('www.langtag.net/broken-tags.txt') do |snippet, comment|
    it "returns false for the #{snippet.inspect} #{"(#{comment})" if comment}" do
      Lang::Tag.wellformed?(snippet).should == false
    end
  end

end

# EOF