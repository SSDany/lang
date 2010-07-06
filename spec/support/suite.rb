module Suite #:nodoc:

  def suite(path, &block)
    suite = FIXTURES_DIR.join(path)
    File.open(suite, File::RDONLY).each_line do |snippet|
      snippet,comment = snippet.split("#",2)
      snippet.strip!
      comment.strip! if comment
      yield(snippet,comment) if block_given?
    end
  end

end

# EOF