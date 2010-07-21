require 'lang/tag'

module Lang #:nodoc:
  class Tag

    # Basic and extended filtering.
    # RFC 4647, sections 3.3.1, 3.3.2
    #
    module Filtering

      WILDCARD = '*'.freeze

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
      # ==== Example
      #   Lang::Tag('de-DE').matched_by_extended_range?('de-*-DE) #=> true
      #   Lang::Tag('de-DE-x-goethe').matched_by_extended_range?('de-*-DE) #=> true
      #   Lang::Tag('de-Latn-DE').matched_by_extended_range?('de-*-DE) #=> true
      #   Lang::Tag('de-Latf-DE').matched_by_extended_range?('de-*-DE) #=> true
      #   Lang::Tag('de-x-DE').matched_by_extended_range?('de-*-DE) #=> false
      #   Lang::Tag('de-Deva').matched_by_extended_range?('de-*-DE) #=> false
      #
      def matched_by_extended_range?(range)

        subtags = decomposition.dup
        subranges = range.to_str.downcase.split(HYPHEN)

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
      #   tag = Lang::Tag('de-Latn-DE')
      #   tag.matched_by_basic_range?('de-Latn-DE') #=> true
      #   tag.matched_by_basic_range?('de-Latn') #=> true
      #   tag.matched_by_basic_range?('*') #=> true
      #   tag.matched_by_basic_range?('de-La') #=> false
      #   tag.matched_by_basic_range?('de-de') #=> false
      #   tag.matched_by_basic_range?('malformedlangtag') #=> false
      #
      def matched_by_basic_range?(range)
        if range.kind_of?(self.class)
          s = range.composition
        elsif range.respond_to?(:to_str)
          return true if range.to_str == WILDCARD
          s = self.class.parse(range).composition
        else
          return false
        end

        composition == s || composition.index(s + HYPHEN) == 0
      rescue
        false
      end

      alias :has_prefix? :matched_by_basic_range?

    end

    include Filtering

  end
end

# EOF