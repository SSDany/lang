require 'lang/tag/pattern'

module Lang

  def self.Tag(thing)
    Lang::Tag.parse(thing)
  end

  # Handles the 'langtag' ABNF production.
  #
  class Tag

    class Error < StandardError
    end

    class InvalidComponentError < Error
    end

    #--
    # Grandfathered tags that do not match the 'langtag' production in the
    # ABNF and would otherwise be invalid are considered 'irregular'
    # grandfathered tags.  With the exception of "en-GB-oed", which is a
    # variant of "en-GB", each of them, in its entirety, represents a
    # language.
    #++

    IRREGULAR = {
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
      'sgn-be-fr'   => 'sfb' ,
      'sgn-be-nl'   => 'vgt' ,
      'sgn-ch-de'   => 'sgg' ,
    }.freeze

    #--
    # Grandfathered tags that (appear to) match the 'langtag' production in
    # Figure 1 are considered 'regular' grandfathered tags.  These tags
    # contain one or more subtags that either do not individually appear in
    # the registry or appear but with a different semantic meaning: each
    # tag, in its entirety, represents a language or collection of
    # languages.
    #++

    GRANDFATHERED = IRREGULAR.merge(
      'art-lojban'  => 'jbo' ,
      'cel-gaulish' => nil   ,
      'no-bok'      => 'nb'  ,
      'no-nyn'      => 'nn'  ,
      'zh-guoyu'    => 'cmn' ,
      'zh-hakka'    => 'hak' ,
      'zh-min'      => nil   ,
      'zh-min-nan'  => 'nan' ,
      'zh-xiang'    => 'hsn'
    ).freeze

    HYPHEN                                = '-'.freeze
    HYPHEN_SPLITTER                       = RUBY_VERSION < '1.9.1' ? /-/.freeze : HYPHEN
    PRIVATEUSE                            = 'x'.freeze

    LANGUAGE_REGEX                        = /^(?:#{PATTERN::LANGUAGE})$/io.freeze
    SCRIPT_REGEX                          = /^(?:#{PATTERN::SCRIPT})$/io.freeze
    REGION_REGEX                          = /^(?:#{PATTERN::REGION})$/io.freeze
    VARIANTS_SEQUENCE_REGEX               = /^(?:#{PATTERN::VARIANT_SEQUENCE}+)$/io.freeze
    EXTENSIONS_SEQUENCE_REGEX             = /^#{PATTERN::EXTENSION_SEQUENCE}+$/io.freeze
    EXTENSIONS_SEQUENCE_SPLITTER          = /(?:^|-)(?=#{PATTERN::SINGLETON}-)/io.freeze
    PRIVATEUSE_REGEX                      = /^#{PATTERN::PRIVATEUSE}$/io.freeze

    LANGTAG_REGEX = /^
      (#{PATTERN::LANGUAGE})              (?# shortest ISO 639 code plus extlang or reserved for future use or registered language subtag)
      (?:-(#{PATTERN::SCRIPT}))?          (?# ISO 15924 code)
      (?:-(#{PATTERN::REGION}))?          (?# ISO 3166-1 code or UN M.49 code)
      (#{PATTERN::VARIANT_SEQUENCE}*)?    (?# registered variants)
      (#{PATTERN::EXTENSION_SEQUENCE}*)?  (?# extensions)
      (?=(?:-#{PATTERN::PRIVATEUSE})?$)   (?# privateuse)
      /iox.freeze

    LANGTAG_WELLFORMEDNESS_REGEX = /^
      (?:#{PATTERN::LANGUAGE})            (?# shortest ISO 639 code plus extlang or reserved for future use or registered language subtag)
      (?:-(?:#{PATTERN::SCRIPT}))?        (?# ISO 15924 code)
      (?:-(?:#{PATTERN::REGION}))?        (?# ISO 3166-1 code or UN M.49 code)
      (?=#{PATTERN::VARIANT_SEQUENCE}*    (?# registered variants)
      #{PATTERN::EXTENSION_SEQUENCE}*     (?# extensions)
      (?:-#{PATTERN::PRIVATEUSE})?$)      (?# privateuse)
      /iox.freeze

    class << self

      # Checks if the +String+ passed represents a 'privateuse' Language-Tag.
      # Works case-insensitively.
      #
      def privateuse?(snippet)
        PRIVATEUSE_REGEX === snippet
      end

      # Checks if the +String+ passed represents an 'irregular' Language-Tag.
      # Works case-insensitively.
      #
      def irregular?(snippet)
        IRREGULAR.key?(snippet) || IRREGULAR.key?(snippet.downcase)
      end

      # Checks if the +String+ passed represents a 'grandfathered' Language-Tag.
      # Works case-insensitively.
      #
      def grandfathered?(snippet)
        GRANDFATHERED.key?(snippet) || GRANDFATHERED.key?(snippet.downcase)
      end

      #--
      # RFC 5646, sec. 2.2.9:
      # A tag is considered "well-formed" if it conforms to the ABNF
      # (Section 2.1). Language tags may be well-formed in terms of syntax
      # but not valid in terms of content. However, many operations
      # involving language tags work well without knowing anything about the
      # meaning or validity of the subtags.
      #++

      # Checks if the +String+ passed represents a well-formed Language-Tag.
      # Works case-insensitively.
      #
      def wellformed?(snippet)
        privateuse?(snippet) || grandfathered?(snippet) || LANGTAG_WELLFORMEDNESS_REGEX === snippet
      end

      def parse(thing)
        return nil unless thing
        return thing if thing.kind_of?(self)
        new.recompose(thing)
      end

    end

    #:section: Components

    attr_reader :language, :script, :region, :variants_sequence, :extensions_sequence, :privateuse_sequence

    #--
    # RFC 5646, sec. 2.2.1:
    # The primary language subtag is the first subtag in a language tag and
    # cannot be omitted, with two exceptions:
    #
    # The single-character subtag 'x' as the primary subtag indicates
    # that the language tag consists solely of subtags whose meaning is
    # defined by private agreement. For example, in the tag "x-fr-CH",
    # the subtags 'fr' and 'CH' do not represent the French language or
    # the country of Switzerland (or any other value in the IANA
    # registry) unless there is a private agreement in place to do so.
    # See Section 4.6.
    #
    # The single-character subtag 'i' is used by some grandfathered tags
    # (see Section 2.2.8) such as "i-klingon" and "i-bnn". (Other
    # grandfathered tags have a primary language subtag in their first
    # position.)
    #++

    #--
    # RFC 5646, sec. 2.2.2:
    # Extended language subtags are used to identify certain specially
    # selected languages that, for various historical and compatibility
    # reasons, are closely identified with or tagged using an existing
    # primary language subtag. Extended language subtags are always used
    # with their enclosing primary language subtag (indicated with a
    # 'Prefix' field in the registry) when used to form the language tag.
    #++

    # Sets the language component for this langtag.
    #
    def language=(value)
      raise InvalidComponentError, "Primary subtag cannot be omitted." unless value
      sequence = value.to_str
      if LANGUAGE_REGEX !~ sequence
        raise InvalidComponentError, "#{value.inspect} does not conform to the 'language' ABNF."
      end
      @language = sequence
      @primary  = nil
      @extlang  = nil
      dirty
      validate
    end

    # Returns a primary language subtag.
    #
    def primary
      return nil unless @language
      decompose_language unless @primary
      @primary
    end

    # Returns a second component of the extended language, if any.
    #
    def extlang
      return nil unless @language
      decompose_language unless @primary
      @extlang
    end

    # Decomposes a language component.
    #
    def decompose_language
      @primary, @extlang = @language.split(HYPHEN_SPLITTER, 2)
      nil
    end

    protected :decompose_language

    #--
    # RFC 5646, sec. 2.2.3:
    # Script subtags are used to indicate the script or writing system
    # variations that distinguish the written forms of a language or its
    # dialects.
    #++

    # Sets the script component for this langtag.
    #
    def script=(value)
      subtag = value ? value.to_str : nil
      if subtag && SCRIPT_REGEX !~ subtag
        raise InvalidComponentError, "#{value.inspect} does not conform to the 'script' ABNF."
      end
      @script = subtag
      dirty
      validate
    end

    #--
    # RFC 5646, sec. 2.2.4:
    # Region subtags are used to indicate linguistic variations associated
    # with or appropriate to a specific country, territory, or region.
    # Typically, a region subtag is used to indicate variations such as
    # regional dialects or usage, or region-specific spelling conventions.
    # It can also be used to indicate that content is expressed in a way
    # that is appropriate for use throughout a region, for instance,
    # Spanish content tailored to be useful throughout Latin America.
    #++

    # Sets the region component for this langtag.
    #
    def region=(value)
      subtag = value ? value.to_str : nil
      if subtag && REGION_REGEX !~ subtag
        raise InvalidComponentError, "#{value.inspect} does not conform to the 'region' ABNF."
      end
      @region = subtag
      dirty
      validate
    end

    #--
    # RFC 5646, sec. 2.2.5:
    # Variant subtags are used to indicate additional, well-recognized
    # variations that define a language or its dialects that are not
    # covered by other available subtags.
    #++

    # Sets the sequence of variants for this langtag.
    #
    # ==== Example
    #
    #   tag = Lang::Tag('ja')
    #   tag.variants_sequence = 'hepburn-heploc'
    #   tag.variants #=> ['hepburn', 'heploc']
    #   tag.has_variant?('heploc') #=> true
    #   tag.has_variant?('nedis') #=> false
    #
    def variants_sequence=(value)
      sequence = value ? value.to_str : nil
      if sequence && VARIANTS_SEQUENCE_REGEX !~ "#{HYPHEN}#{sequence}"
        raise InvalidComponentError, "#{value.inspect} does not conform to the 'variants' ABNF."
      end
      set_variants_sequence(sequence)
      dirty
      validate
    end

    # Friendly version of the #variants_sequence=.
    # Sets the sequence of variants for this langtag.
    #
    # ==== Example
    #
    #   tag = Lang::Tag('sl')
    #   tag.variants = ['rozaj', 'solba', '1994']
    #   tag.variants_sequence #=> 'rozaj-solba-1994'
    #   tag.variants #=> ['rozaj', 'solba', '1994']
    #
    def variants=(value)
      subtags = Array(value).flatten
      if subtags.empty?
        self.variants_sequence = nil
      else
        self.variants_sequence = subtags.join(HYPHEN)
        @variants = subtags
      end
    end

    # Returns a list of variants of this lantag.
    #
    def variants
      return nil unless @variants_sequence
      @variants ||= @variants_sequence.split(HYPHEN_SPLITTER)
    end

    def set_variants_sequence(sequence)
      if sequence && sequence.downcase.split(HYPHEN_SPLITTER).uniq!
        raise InvalidComponentError, "#{sequence.inspect} sequence includes repeated variants."
      end
      @variants_sequence = sequence
      @variants = nil
      nil
    end

    protected :set_variants_sequence

    # Checks if self has a variant or a sequence of
    # variants passed. Works case-insensitively.
    #
    def has_variant?(sequence)
      return false unless @variants_sequence
      /(?:^|-)#{sequence}(?:-|$)/i === @variants_sequence
    end

    #--
    # RFC 5646, sec. 2.2.6:
    # Extensions provide a mechanism for extending language tags for use in
    # various applications. They are intended to identify information that
    # is commonly used in association with languages or language tags but
    # that is not part of language identification.
    #++

    # Sets the sequence of extensions for this langtag.
    #
    def extensions_sequence=(value)
      sequence = value ? value.to_str : nil
      if sequence && EXTENSIONS_SEQUENCE_REGEX !~ "#{HYPHEN}#{sequence}"
        raise InvalidComponentError, "#{value.inspect} does not conform to the 'extensions' ABNF."
      end
      set_extensions_sequence(sequence)
      dirty
      validate
    end

    # Friendly version of the #extensions_sequence=.
    # Sets the sequence of extensions for this langtag.
    #
    def extensions=(value)
      subtags = Array(value).flatten
      self.extensions_sequence = subtags.empty? ? nil : subtags.join(HYPHEN)
    end

    def set_extensions_sequence(sequence)
      if sequence
        exthash = {}
        sequence.split(EXTENSIONS_SEQUENCE_SPLITTER).each do |seq|
          k,v = seq[0...1], seq[2..-1] # sequence.split(HYPHEN_SPLITTER,2)
          k.downcase!
          if exthash.key?(k)
            raise InvalidComponentError, "#{sequence.inspect} sequence includes repeated singletons."
          end
          exthash[k] = v
        end
        @extensions_sequence = sequence
        @extensions = exthash
      else
        @extensions_sequence = nil
        @extensions = nil
      end
      nil
    end

    protected :set_extensions_sequence

    # Builds an *ordered* list of *downcased* singletons.
    #
    def singletons
      return nil unless @extensions
      keys = @extensions.keys
      keys.sort!
      keys
    end

    # Returns a sequense of subtags for a singleton passed.
    # Works case-insensitively.
    #
    def extension(key)
      return nil unless @extensions
      sequence = @extensions[key] || @extensions[key = key.downcase]
      return sequence unless String === sequence
      @extensions[key] = sequence.split(HYPHEN) #lazy
      @extensions[key]
    end

    # Checks if self has a singleton passed.
    # Works case-insensitively.
    #
    def has_singleton?(key)
      return false unless @extensions
      @extensions.key?(key) || @extensions.key?(key.downcase)
    end

    alias :has_extension? :has_singleton?

    #--
    # RFC 5646, sec. 2.2.7:
    # Private use subtags are used to indicate distinctions in language
    # that are important in a given context by private agreement.
    #
    # RFC 5646, sec. 2.2.7:
    # For example, suppose a group of scholars is studying some texts in
    # medieval Greek.  They might agree to use some collection of private
    # use subtags to identify different styles of writing in the texts.
    # For example, they might use 'el-x-koine' for documents in the
    # "common" style while using 'el-x-attic' for other documents that
    # mimic the Attic style.  These subtags would not be recognized by
    # outside processes or systems, but might be useful in categorizing
    # various texts for study by those in the group.
    #++

    def privateuse
      return nil unless @privateuse_sequence
      @privateuse ||= @privateuse_sequence.split(HYPHEN)[1..-1]
    end

    # Friendly version of the #privateuse_sequence=.
    # Sets the 'privateuse' sequence for this langtag.
    #
    # ==== Example
    #
    #   tag = Lang::Tag('de')
    #   tag.privateuse = ['private', 'use', 'sequence']
    #   tag.privateuse_sequence #=> 'x-private-use-sequence'
    #
    def privateuse=(value)
      subtags = Array(value).flatten
      if subtags.empty?
        self.privateuse_sequence = nil
      else
        self.privateuse_sequence = subtags.unshift(PRIVATEUSE).join(HYPHEN)
        @privateuse = subtags
      end
    end

    # Sets the 'privateuse' sequence for this langtag.
    #
    def privateuse_sequence=(value)
      sequence = value ? value.to_str : nil
      if sequence && PRIVATEUSE_REGEX !~ sequence
        raise InvalidComponentError, "#{value.inspect} does not conform to the 'privateuse' ABNF."
      end
      @privateuse_sequence = sequence
      @privateuse = nil
      dirty
      validate
    end

    #:section: Comparison

    # Returns +true+ if langtag objects are equal.
    # Allows comparison against +Strings+.
    #
    def ===(other)
      return false unless other.respond_to?(:to_str)
      s = other.to_str
      composition == s || composition == s.downcase
    end

    # Returns +true+ if Lang::Tag objects are equal.
    #
    def ==(other)
      return false unless other.kind_of?(self.class)
      self.composition == other.composition
    end

    def eql?(other)
      return false unless other.kind_of?(self.class)
      self.to_s == other.to_s
    end

    def hash
      to_s.hash
    end

    #:section: Validation

    def dirty
      @composition = nil
      @decomposition = nil
      @tag = nil
      nil
    end

    private :dirty

    def defer_validation(&block)
      raise LocalJumpError, "No block given." unless block
      @validation_deferred = true
      yield
      @validation_deferred = false
      validate
      nil
    end

    def validate
      return if !!@validation_deferred
      if self.class.grandfathered?(composition)
        raise Error, "Grandfathered Language-Tag: #{to_s.inspect}."
      elsif @language.nil?
        raise InvalidComponentError, "Primary subtag cannot be omitted."
      end
      nil
    end

    private :validate

    #:section: Formatting

    def nicecase!

      if @language
        @language.downcase!
        @primary = nil
        @extlang = nil
      end

      # [ISO639-1] recommends that language codes be written in lowercase ('mn' Mongolian).
      # [ISO15924] recommends that script codes use lowercase with the initial letter capitalized ('Cyrl' Cyrillic).
      # [ISO3166-1] recommends that country codes be capitalized ('MN' Mongolia).

      @script.capitalize!             if @script
      @region.upcase!                 if @region
      @variants_sequence.downcase!    if @variants_sequence
      @extensions_sequence.downcase!  if @extensions_sequence
      @privateuse_sequence.downcase!  if @privateuse_sequence

      @tag = nil
    end

    def nicecase
      duplicated = self.dup
      duplicated.nicecase!
      duplicated
    end

    #:section: Miscellaneous

    def inspect
      sprintf("#<%s:%#0x %s>", self.class.to_s, self.object_id, self.to_s)
    end

    def composition
      @composition ||= to_s.downcase
    end

    def to_s
      return @tag if @tag
      @tag = ""
      @tag << @language if @language
      @tag << HYPHEN << @script if @script
      @tag << HYPHEN << @region if @region
      @tag << HYPHEN << @variants_sequence if @variants_sequence
      @tag << HYPHEN << @extensions_sequence if @extensions_sequence
      @tag << HYPHEN << @privateuse_sequence if @privateuse_sequence
      @tag
    end

    alias :to_str :to_s

    def to_a
      to_s.split(HYPHEN)
    end

    def decomposition
      @decomposition ||= composition.split(HYPHEN)
    end

    private :decomposition

    # Duplicates self.
    #
    def dup
      self.class.new.recompose(to_s)
    end

    def length
      to_s.length
    end

    # Returns the number of subtags in self.
    #
    def subtags_count
      to_s.count(HYPHEN) + 1
    end

    def recompose(thing)

      raise TypeError, "Can't convert #{thing.class} into String" unless thing.respond_to?(:to_str)
      tag = thing.to_str

      if !self.class.grandfathered?(tag) && LANGTAG_REGEX === tag

        dirty

        @tag                    = tag
        @primary                = nil
        @extlang                = nil
        @language               = $1
        @script                 = $2
        @region                 = $3
        set_variants_sequence     $4[1..-1]
        set_extensions_sequence   $5[1..-1]
        @privateuse_sequence    = $'[1..-1]
        @privateuse             = nil

      else
        raise ArgumentError, "Ill-formed, grandfathered or 'privateuse' Language-Tag: #{thing.inspect}."
      end
      self
    end

  end
end

# EOF