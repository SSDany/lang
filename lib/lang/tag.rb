require 'lang/tag/pattern'
require 'lang/tag/composition'
require 'lang/tag/langtag'
require 'lang/tag/grandfathered'
require 'lang/tag/privateuse'

module Lang

  def self.Tag(thing)
    #return thing if Tag::Composition === thing
    Tag::Grandfathered(thing) rescue
    Tag::Langtag(thing) rescue
    Tag::Privateuse(thing)
  rescue
    raise ArgumentError, "#{thing.inspect} is not a language tag."
  end

  module Tag

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
      (?:#{PATTERN::LOOSE_LANGUAGE})      (?# shortest ISO 639 code plus at most 3 extlangs or reserved for future use or registered language subtag)
      (?:-(?:#{PATTERN::SCRIPT}))?        (?# ISO 15924 code)
      (?:-(?:#{PATTERN::REGION}))?        (?# ISO 3166-1 code or UN M.49 code)
      (?=#{PATTERN::VARIANT_SEQUENCE}*    (?# registered variants)
      #{PATTERN::EXTENSION_SEQUENCE}*     (?# extensions)
      (?:-#{PATTERN::PRIVATEUSE})?$)      (?# privateuse)
      /iox.freeze

    class << self

      # Checks if the +String+ passed represents a 'privateuse' language tag.
      # Works case-insensitively.
      #
      def privateuse?(snippet)
        PRIVATEUSE_REGEX === snippet
      end

      # Checks if the +String+ passed represents a 'grandfathered' language tag.
      # Works case-insensitively.
      #
      def grandfathered?(snippet)
        GRANDFATHERED.key?(snippet) || GRANDFATHERED.key?(snippet.downcase)
      end

      #--
      # RFC 5646, Section 2.2.9:
      # A tag is considered "well-formed" if it conforms to the ABNF
      # (Section 2.1). Language tags may be well-formed in terms of syntax
      # but not valid in terms of content. However, many operations
      # involving language tags work well without knowing anything about the
      # meaning or validity of the subtags.
      #++

      # Checks if the +String+ passed represents a well-formed language tag.
      # Works case-insensitively.
      #
      def wellformed?(snippet)
        privateuse?(snippet) || grandfathered?(snippet) || LANGTAG_WELLFORMEDNESS_REGEX === snippet
      end

    end

  end
end

# EOF