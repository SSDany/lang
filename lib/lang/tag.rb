module Lang #:nodoc:
  class Tag

    HYPHEN          = '-'.freeze
    HYPHEN_SPLITTER = RUBY_VERSION < '1.9.1' ? /-/.freeze : HYPHEN
    WILDCARD        = '*'.freeze

    GRANDFATHERED_TAGS = {
      'art-lojban'  => 'jbo' ,
      'cel-gaulish' => nil   ,
      'en-gb-oed'   => nil   ,
      'i-ami'       => 'ami' ,
      'i-bnn'       => 'bnn' ,
      'i-default'   => nil   ,
      'i-enochian'  => nil   ,
      'i-hak'       => 'hak' ,
      'i-klingon'   => 'tlh' ,
      'i-lux'       => 'lb'  ,
      'i-mingo'     => nil   ,
      'i-navajo'    => 'nv'  ,
      'i-pwn'       => 'pwn' ,
      'i-tao'       => 'tao' ,
      'i-tay'       => 'tay' ,
      'i-tsu'       => 'tsu' ,
      'no-bok'      => 'nb'  ,
      'no-nyn'      => 'nn'  ,
      'sgn-be-fr'   => 'sfb' ,
      'sgn-be-nl'   => 'vgt' ,
      'sgn-ch-de'   => 'sgg' ,
      'zh-guoyu'    => 'cmn' ,
      'zh-hakka'    => 'hak' ,
      'zh-min'      => nil   ,
      'zh-min-nan'  => 'nan' ,
      'zh-xiang'    => 'hsn' 
    }.freeze

    attr_accessor :primary, :extlang, :script, :region, :variants, :extensions, :privateuse

    #--
    # RFC 5646, sec. 2.2.2:
    # Although the ABNF production 'extlang' permits up to three
    # extended language tags in the language tag, extended language
    # subtags MUST NOT include another extended language subtag in
    # their 'Prefix'. That is, the second and third extended language
    # subtag positions in a language tag are permanently reserved and
    # tags that include those subtags in that position are, and will
    # always remain, invalid.
    #++

    language    = '([a-z]{2,8}|[a-z]{2,3}(?:-[a-z]{3}){0,3})'
    script      = '(?:-([a-z]{4}))?'
    region      = '(?:-([a-z]{2}|\d{3}))?'
    variants    = '(?:-[a-z\d]{5,8}|-\d[a-z\d]{3})*'
    extensions  = '(?:-[a-wy-z\d]{1}(?:-[a-z\d]{2,8})+)*'
    privateuse  = '(?:-x(?:-[a-z\d]{1,8})+)?'

    LANGTAG_COMPOSITION_REGEX   = /^#{language}#{script}#{region}(?=#{variants}#{extensions}#{privateuse}$)/o.freeze
    LANGTAG_INFO_REGEX          = /^#{language}#{script}#{region}(#{variants})#{extensions}#{privateuse}$/o.freeze
    PRIVATEUSE_REGEX            = /^x(?:-[a-z\d]{1,8})+$/i.freeze

    PRIVATEUSE = 'x'.freeze

    class << self

      # Checks if the +String+ passed represents a 'privateuse' Language-Tag.
      # Works case-insensitively.
      #
      def privateuse?(tag)
        PRIVATEUSE_REGEX === tag
      end

      # Checks if the +String+ passed represents a 'grandfathered' Language-Tag.
      # Works case-insensitively.
      #
      def grandfathered?(tag)
        GRANDFATHERED_TAGS.key?(tag) || GRANDFATHERED_TAGS.key?(tag.downcase)
      end

      # Checks if the +String+ passed represents a LangTag,
      # i.e. nor 'grandfathered' nor 'privateuse' Language-Tag.
      # Works case-insensitively.
      #
      def langtag?(tag)
        parse(tag)
        true
      rescue
        false
      end

      # Checks if the +String+ passed represents a well-formed Language-Tag.
      # Works case-insensitively.
      #
      def wellformed?(tag)
        privateuse?(tag) || grandfathered?(tag) || langtag?(tag)
      end

      def info(thing)
        tag = thing.downcase
        return nil if GRANDFATHERED_TAGS.key?(thing)
        return nil unless LANGTAG_INFO_REGEX === tag

        primary     = $1
        extlang     = nil
        script      = $2
        region      = $3
        variants    = $4.split(HYPHEN_SPLITTER)[1..-1]

        primary, *extlang = primary.split(HYPHEN_SPLITTER) if primary.include?(HYPHEN)
        script.capitalize! if script
        region.upcase! if region

        [primary, extlang, script, region, variants]
      end

      def parse(thing)
        return nil unless thing
        return thing if thing.kind_of?(self)
        self.new.recompose(thing)
      end

    end

    # Checks if self has a variant passed.
    # Works case-insensitively.
    #
    def has_variant?(variant)
      return false unless @variants
      v = variant.downcase
      @variants.any? { |var| v == var || v == var.downcase }
    end

    # Checks if self has a singleton passed.
    # Works case-insensitively.
    #
    def has_singleton?(key)
      return false unless @extensions
      @extensions.key?(key) || @extensions.key?(key.downcase)
    end

    alias :extension? :has_singleton?

    # Builds an ordered list of singletons.
    #
    def singletons
      return nil unless @extensions
      keys = @extensions.keys
      keys.sort!
      keys
    end

    def initialize(thing = nil)
      recompose(thing) if thing
    end

    # Builds the +String+, which represents self.
    # Does *not* check well-formedness.
    # Does *not* perform recomposition.
    #
    def compose
      to_a.join(HYPHEN)
    end

    # Returns the number of subtags in self.
    # Does *not* check well-formedness.
    # Does *not* perform recomposition.
    #
    def length
      length = 0
      length += 1 if @primary
      length += @extlang.length if @extlang
      length += 1 if @script
      length += 1 if @region
      length += @variants.length if @variants
      @extensions.each { |_,e| length += e.length+1 } if @extensions
      length += @privateuse.length+1 if @privateuse
      length
    rescue
      raise "LanguageTag has at least one malformed component: #{self.inspect}"
    end

    def nicecased(force_recomposition = true)
      recompose if force_recomposition
      @nicecased  #.dup
    end

    def to_a
      ary = [@primary]
      ary.concat @extlang if @extlang
      ary << @script if @script
      ary << @region if @region
      ary.concat @variants if @variants
      singletons.each { |s| (ary << s).concat @extensions[s] } if @extensions
      (ary << PRIVATEUSE).concat @privateuse if @privateuse
      ary
    rescue
      raise "LanguageTag has at least one malformed component: #{self.inspect}"
    end

    #--
    # RFC 4647, sec. 3.3.2 ('Extended Filtering')
    #
    # Much like basic filtering, extended filtering selects content with
    # arbitrarily long tags that share the same initial subtags as the
    # language range.  In addition, extended filtering selects language
    # tags that contain any intermediate subtags not specified in the
    # language range.  For example, the extended language range "de-*-DE"
    # (or its synonym "de-DE") matches all of the following tags:
    #
    #   de-DE (German, as used in Germany)
    #   de-de (German, as used in Germany)
    #   de-Latn-DE (Latin script)
    #   de-Latf-DE (Fraktur variant of Latin script)
    #   de-DE-x-goethe (private-use subtag)
    #   de-Latn-DE-1996 (orthography of 1996)
    #   de-Deva-DE (Devanagari script)
    #
    # The same range does not match any of the following tags for the
    # reasons shown:
    #
    #   de (missing 'DE')
    #   de-x-DE (singleton 'x' occurs before 'DE')
    #   de-Deva ('Deva' not equal to 'DE')
    #++

    # Checks if the *extended* Language-Range (in the shortest notation)
    # passed matches self.
    #
    def matched_by_extended_range?(range)
      recompose
      subtags = @composition.split(HYPHEN)
      subranges = range.downcase.split(HYPHEN)

      subrange = subranges.shift
      subtag = subtags.shift

      while subrange
        if subrange == WILDCARD
          subrange = subranges.shift
        elsif subtag == nil
          return false
        elsif subtag == subrange
          subtag = subtags.shift
          subrange = subranges.shift
        elsif subtag.size == 1
          return false
        else
          subtag = subtags.shift
        end
      end
      true
    rescue
      false
    end

    #--
    # RFC 4647, sec. 3.3.1 ('Basic Filtering')
    #
    # A language range matches a
    # particular language tag if, in a case-insensitive comparison, it
    # exactly equals the tag, or if it exactly equals a prefix of the tag
    # such that the first character following the prefix is "-".  For
    # example, the language-range "de-de" (German as used in Germany)
    # matches the language tag "de-DE-1996" (German as used in Germany,
    # orthography of 1996), but not the language tags "de-Deva" (German as
    # written in the Devanagari script) or "de-Latn-DE" (German, Latin
    # script, as used in Germany).
    #++

    # Checks if the *basic* Language-Range passed matches self.
    #
    # ==== Example
    #   tag = LanguageTag.parse('de-Latn-DE')
    #   tag.matched_by_basic_range?('de-Latn-DE') #=> true
    #   tag.matched_by_basic_range?('de-Latn') #=> true
    #   tag.matched_by_basic_range?('*') #=> true
    #   tag.matched_by_basic_range?('de-La') #=> false
    #   tag.matched_by_basic_range?('de-de') #=> false
    #   tag.matched_by_basic_range?('malformedlangtag') #=> false
    #
    def matched_by_basic_range?(range)
      if range.kind_of?(self.class)
        s = range.nicecased
      elsif range.respond_to?(:to_str)
        return true if range.to_str == WILDCARD
        s = self.class.parse(range).nicecased(false)
      else
        return false
      end
      recompose
      @nicecased == s || @nicecased.index(s + HYPHEN) == 0
    rescue
      false
    end

    alias :has_prefix? :matched_by_basic_range?

    def ==(other)
      return false unless other.kind_of?(self.class)
      composition, s = compose, other.compose
      composition == s || composition.downcase == s.downcase
    end

    def ===(other)
      if other.kind_of?(self.class)
        s = other.compose
      elsif other.respond_to?(:to_str)
        s = other.to_str
      else
        return false
      end
      composition = compose
      composition == s || composition.downcase == s.downcase
    end

    # Checks well-formedness of self.
    #
    # ==== Notes
    # This check is deferred by default.
    # You may create malformed/invalid tags, and still
    # be able to compare and modify them. Only note, that
    # things like 'filtering' and 'lookup' *requires* the
    # tag to be recomposed and checked first.
    #
    def langtag?
      !!recompose rescue false
    end

    # Recomposes self.
    #
    def recompose(thing = nil)

      tag = nil
      composition = compose

      if thing
        raise TypeError, "Can't convert #{thing.class} into String" unless thing.respond_to?(:to_str)
        return self if composition == (tag = thing.to_str) ||
                       composition.downcase == (tag = tag.downcase)
      else
        return self if @nicecased == (tag = composition) ||
                       @composition == tag ||
                       @composition == (tag = tag.downcase)
      end

      if !GRANDFATHERED_TAGS.key?(tag) && LANGTAG_COMPOSITION_REGEX === tag

        @primary    = $1
        @extlang    = nil
        @script     = $2
        @region     = $3
        components  = $'.split(HYPHEN_SPLITTER)
        components.shift

        @primary, *@extlang = @primary.split(HYPHEN_SPLITTER) if @primary.include?(HYPHEN)
        @script.capitalize! if @script
        @region.upcase! if @region

        @extensions = nil
        @variants   = nil
        singleton   = nil

        while c = components.shift
          if c.size == 1
            break if c == PRIVATEUSE
            @extensions ||= {}
            if @extensions.key?(c)
              raise ArgumentError, "Malformed langtag (repeated singleton: #{c.inspect}): #{thing.inspect}"
            end
            singleton = c
            @extensions[singleton = c] = []
          elsif singleton
            @extensions[singleton] << c
          else
            @variants ||= []
            if @variants.include?(c)
              raise ArgumentError, "Malformed langtag (repeated variant: #{c.inspect}): #{thing.inspect}"
            end
            @variants << c
          end
        end

        @privateuse   = components.empty? ? nil : components
        @nicecased    = compose
        @composition  = @nicecased.downcase

      else
        raise ArgumentError, "Malformed, grandfathered or 'privateuse' Language-Tag: #{thing.inspect}"
      end

      self
    end

  end
end

# EOF