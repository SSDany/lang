require 'lang/tag'
require 'lang/subtags'

module Lang #:nodoc:
  class Tag

    module Canonicalization

      # Handles exceptions that might
      # appear in canonicalization or validation processes.
      #
      class Error < Tag::Error
      end

      #--
      # RFC 5646, Section 3.1.7
      # Extended language subtags always have a mapping to their
      # identical primary language subtag.  For example, the extended
      # language subtag 'yue' (Cantonese) can be used to form the tag
      # "zh-yue".  It has a 'Preferred-Value' mapping to the primary
      # language subtag 'yue', meaning that a tag such as
      # "zh-yue-Hant-HK" can be canonicalized to "yue-Hant-HK".
      #++

      def canonicalize_language
        #return unless @language
        raise InvalidComponentError, "Language can not be omitted." unless @language
        decompose_language unless @primary


        if @extlang
          subtag = Subtags::Extlang(@extlang)
          raise Error, "Extlang #{@extlang.inspect} is not registered." unless subtag

          # RFC 5646, Section 2.2.2
          # Extended language subtag records MUST include a 'Preferred-
          # Value'. The 'Preferred-Value' and 'Subtag' fields MUST be
          # identical.

          # RFC 5646, Section 4.5
          # For extlangs, the original primary language subtag is also
          # replaced if there is a primary language subtag in the 'Preferred-Value'.
          # The 'Preferred-Value' field in subtag records of type "extlang" also
          # contains an "extended language range".  This allows the subtag to be
          # deprecated in favor of either a single primary language subtag or a
          # new language-extlang sequence.

          @language = subtag.preferred_value
          @primary = nil
          @extlang = nil
        else
          subtag = Subtags::Language(@primary)
          raise Error, "Language #{@primary.inspect} is not registered." unless subtag
          @language = subtag.preferred_value if subtag.preferred_value
          @primary = nil
        end

        dirty
        nil
      end

      protected :canonicalize_language

      #--
      # RFC 5646, Section 2.2.3
      # The script subtags 'Qaaa' through 'Qabx' are reserved for private
      # use in language tags. These subtags correspond to codes reserved
      # by ISO 15924 for private use. These codes MAY be used for non-
      # registered script values. Please refer to Section 4.6 for more
      # information on private use subtags.
      #++

      PRIVATE_SCRIPT_REGEX = /^Qa[ab][a-x]$/i.freeze

      def canonicalize_script
        return if !@script || PRIVATE_SCRIPT_REGEX === @script
        subtag = Subtags::Script(@script)
        raise Error, "Script #{@script.inspect} is not registered." unless subtag
        @script = subtag.preferred_value if subtag.preferred_value
        dirty
      end

      protected :canonicalize_script

      #--
      # RFC 5646, Section 2.2.4
      # The region subtags 'AA', 'QM'-'QZ', 'XA'-'XZ', and 'ZZ' are
      # reserved for private use in language tags. These subtags
      # correspond to codes reserved by ISO 3166 for private use.  These
      # codes MAY be used for private use region subtags (instead of
      # using a private use subtag sequence). Please refer to
      # Section 4.6 for more information on private use subtags.
      #++

      PRIVATE_REGION_REGEX = /^(?:AA|Q[M-Z]|X[A-Z]|ZZ)$/i.freeze

      #--
      # RFC 5646, Section 4.5
      # Example: Although the tag "en-BU" (English as used in Burma)
      # maintains its validity, the language tag "en-BU" is not in canonical
      # form because the 'BU' subtag has a canonical mapping to 'MM'
      # (Myanmar).
      #++

      def canonicalize_region
        return if !@region || PRIVATE_REGION_REGEX === @region
        subtag = Subtags::Region(@region)
        raise Error, "Region #{@region.inspect} is not registered." unless subtag
        @region = subtag.preferred_value if subtag.preferred_value #|| subtag.name
        dirty
      end

      protected :canonicalize_region

      def canonicalize_variants
        return unless @variants_sequence
        @variants.map! do |variant|
          v = Subtags::Variant(variant)
          raise Error, "Variant #{variant.inspect} is not registered." unless v
          v.preferred_value || variant
        end
        @variants_sequence = @variants.join(HYPHEN)
        dirty
      end

      protected :canonicalize_variants

      #--
      # RFC 5646, Section 4.5
      # Example: The language tag "en-a-aaa-b-ccc-bbb-x-xyz" is in canonical
      # form, while "en-b-ccc-bbb-a-aaa-X-xyz" is well-formed and potentially
      # valid (extensions 'a' and 'b' are not defined as of the publication
      # of this document) but not in canonical form (the extensions are not
      # in alphabetical order).
      #++

      EXTENSION_SEQUENCE_C_SPLITTER = /(?:^|-)(?=#{PATTERN::SINGLETON}-)/io.freeze

      def canonicalize_extensions
        return unless @extensions_sequence
        @extensions_sequence = @extensions_sequence.
          split(EXTENSION_SEQUENCE_C_SPLITTER).
          sort{ |k,v| k.downcase <=> v.downcase }.
          join(HYPHEN)
        dirty
      end

      protected :canonicalize_extensions

      #--
      # RFC 5646, Section 3.1.7
      # For example, the tags "zh-yue-Hant-HK" and "yue-Hant-HK"
      # are semantically equivalent and ought to be treated as
      # if they were the same tag.
      #++

      def same?(other)
        self.canonicalize == other.canonicalize
      end

      def canonicalize
        duplicated = self.dup
        duplicated.canonicalize!
        duplicated
      end

      def canonicalize!

        # 1. Extension sequences are ordered into case-insensitive ASCII order
        # by singleton subtag.

        canonicalize_extensions

        # A redundant tag is a grandfathered
        # registration whose individual subtags appear with the same semantic
        # meaning in the registry. For example, the tag "zh-Hant" (Traditional
        # Chinese) can now be composed from the subtags 'zh' (Chinese) and
        # 'Hant' (Han script traditional variant). These redundant tags are
        # maintained in the registry as records of type 'redundant', mostly as
        # a matter of historical curiosity.

        # 2. Redundant or grandfathered tags are replaced by their 'Preferred-
        # Value', if there is one.

        # TODO: "sgn-Qaaa-JP" => ("sgn-JP" = "jsl") => "jsl-Qaaa" ?
        if re = Subtags::Redundant(composition)
          return recompose(re.preferred_value) if re.preferred_value
        end

        # 3. Subtags are replaced by their 'Preferred-Value', if there is one.
        # For extlangs, the original primary language subtag is also
        # replaced if there is a primary language subtag in the 'Preferred-
        # Value'.

        canonicalize_language
        canonicalize_script
        canonicalize_region
        canonicalize_variants

        nil
      end

      alias :canonize  :canonicalize
      alias :canonize! :canonicalize!

      def to_extlang_form!
        canonicalize!
        subtag = Subtags::Extlang(@language)
        @primary = subtag.prefix
        @extlang = @language
        @language = "#{@primary}#{HYPHEN}#{@extlang}"
        dirty
        nil
      end

      def to_extlang_form
        duplicated = self.dup
        duplicated.to_extlang_form!
        duplicated
      end

      def validate_language
        return unless @language
        decompose_language unless @primary
        if @extlang
          subtag = Subtags::Extlang(@extlang)

          # RFC 5646, Section 3.4
          # Extended language subtag records MUST include exactly one
          # 'Prefix' field indicating an appropriate subtag or sequence of
          # subtags for that extended language subtag.

          unless subtag.prefix == @primary || subtag.prefix == @primary.downcase
            raise Error, "Extlang #{@extlang.inspect} requires prefix #{subtag.prefix.inspect}."
          end

        elsif !Subtags::Language(@primary)
          raise Error, "Language #{@primary.inspect} is not registered."
        end
        nil
      end

      def validate_script
        return if !@script || PRIVATE_SCRIPT_REGEX === @script
        raise Error, "Script #{@script.inspect} is not registered" unless Subtags::Script(@script)
        nil
      end

      def validate_region
        return if !@region || PRIVATE_REGION_REGEX === @region
        raise Error, "Region #{@region.inspect} is not registered" unless Subtags::Region(@region)
        nil
      end

      #--
      # RFC 5646, Section 3.1.8
      # The 'Prefix' also indicates when variant subtags make sense when used
      # together (many that otherwise share a 'Prefix' are mutually
      # exclusive) and what the relative ordering of variants is supposed to
      # be. For example, the variant '1994' (Standardized Resian
      # orthography) has several 'Prefix' fields in the registry ("sl-rozaj",
      # "sl-rozaj-biske", "sl-rozaj-njiva", "sl-rozaj-osojs", and "sl-rozaj-
      # solba").  This indicates not only that '1994' is appropriate to use
      # with each of these five Resian variant subtags ('rozaj', 'biske',
      # 'njiva', 'osojs', and 'solba'), but also that it SHOULD appear
      # following any of these variants in a tag. Thus, the language tag
      # ought to take the form "sl-rozaj-biske-1994", rather than "sl-1994-
      # rozaj-biske" or "sl-rozaj-1994-biske".
      #++

      PREFIX_REGEX = /^(#{PATTERN::LANGUAGE})(?:-(#{PATTERN::SCRIPT}))?(?:-(#{PATTERN::REGION}))?(?:-(.+))?$/io.freeze

      # Validates the sequence of variants according 'Prefix' rules
      # as described in RFC 5646, section 3.1.8.
      #
      def validate_variants
        return unless @variants_sequence

        sequence = nil
        @variants.each do |variant|
          v = Subtags::Variant(variant)
          raise Error, "Variant #{variant.inspect} is not registered." unless v

          # RFC 5646, Section 3.1.4
          # The 'Subtag' field-body MUST follow the casing conventions described
          # in Section 2.1.1. All subtags use lowercase letters in the field-
          # body, with two exceptions:
          # - Subtags whose 'Type' field is 'script' (in other words, subtags
          #   defined by ISO 15924) MUST use titlecase.
          # - Subtags whose 'Type' field is 'region' (in other words, the non-
          #   numeric region subtags defined by ISO 3166-1) MUST use all
          #   uppercase.

          if !v.prefixes || v.prefixes.any? { |prefix|
              PREFIX_REGEX === prefix # quick parse
              ($4 == nil || $4 == sequence) && # required sequence of variants
              ($3 == nil || @region && ($3 == @region || $3 == @region.upcase)) && # required region
              ($2 == nil || @script && ($2 == @script || $2 == @script.capitalize)) && # required script
              ($1 == @language || $1 == @language.downcase) # required language
            }

            sequence ? sequence << HYPHEN : sequence = ""
            sequence << v.name

          else raise Error,
            "Variant #{variant.inspect} requires " \
            "one of following prefixes: " \
            "#{v.prefixes.map{ |p| p.inspect }.join(", ")}."
          end
        end
        nil
      end

      #--
      # RFC 5646, Section 4.1
      # The script subtag SHOULD NOT be used to form language tags unless
      # the script adds some distinguishing information to the tag.
      # ...
      # The field 'Suppress-Script' in the primary or extended language
      # record in the registry indicates script subtags that do not add
      # distinguishing information for most applications; this field
      # defines when users SHOULD NOT include a script subtag with a
      # particular primary language subtag.
      #
      # For example, if an implementation selects content using Basic
      # Filtering [RFC4647] (originally described in Section 14.4 of
      # [RFC2616]) and the user requested the language range "en-US",
      # content labeled "en-Latn-US" will not match the request and thus
      # not be selected. Therefore, it is important to know when script
      # subtags will customarily be used and when they ought not be used.
      #++

      def suppress_script!
        return unless @script && @language
        decompose_language unless @primary

        subtag = Subtags::Language(@primary)
        raise Error, "Language #{@primary.inspect} is not registered." unless subtag
        if subtag.suppress_script && @script == subtag.suppress_script
          @script = nil
        #elsif @extlang
        #  subtag = Subtags::Extlang(@extlang)
        #  raise Error, "Extlang #{@extlang.inspect} is not registered." unless subtag
        #  @script = nil if subtag.suppress_script && @script == subtag.suppress_script
        end
        dirty
        nil
      end

      def suppress_script
        duplicated = self.dup
        duplicated.suppress_script!
        duplicated
      end

    end

    include Canonicalization

  end
end

# EOF