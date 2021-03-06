module Lang #:nodoc:
  module Tag

    # Handles abstract compositions of subtags
    # incl. basic and extended language-ranges.
    #
    # ==== Example
    #
    #   class LanguageRange < Lang::Tag::Composition
    #
    #     def initialize(thing)
    #       raise TypeError, "Can't convert #{thing.class} into String" unless thing.respond_to?(:to_str)
    #       sequence = thing.to_str
    #       unless /^(?:\*|[a-z]{1,8})(?:-[a-z\d]{1,8}|-\*)*$/i === sequence
    #         raise Error, "#{sequence.inspect} is not a language-range."
    #       end
    #       @sequence = sequence
    #     end
    #
    #     def simplify! # to basic language-range
    #       /^\*-/ === @sequence ? @sequence = '*' : @sequence.gsub!('-*','')
    #       dirty
    #     end
    #
    #   end
    #
    class Composition

      def initialize(thing)
        raise TypeError, "Can't convert #{thing.class} into String" unless thing.respond_to?(:to_str)
        @sequence = thing.to_str
      end

      # Returns +true+ if compositions are equal.
      # Allows comparison against +Strings+.
      #
      def ===(other)
        return false unless other.respond_to?(:to_str)
        s = other.to_str
        composition == s || composition == s.downcase
      end

      # Returns +true+ if Compositions are equal.
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

      def composition
        @composition ||= to_s.downcase
      end

      def to_s
        @sequence
      end

      alias :to_str :to_s

      def to_a
        to_s.split(HYPHEN_SPLITTER)
      end

      def decomposition
        @decomposition ||= composition.split(HYPHEN_SPLITTER)
      end

      private :decomposition

      def dirty
        @composition = nil
        @decomposition = nil
        nil
      end

      private :dirty

      # Duplicates self.
      #
      def dup
        self.class.new(to_s.dup)
      end

      def length
        to_s.length
      end

      # Returns the number of subtags in self.
      #
      def subtags_count
        to_s.count(HYPHEN) + 1
      end

      #--
      # RFC 5646, Section 2.1.1
      # An implementation can reproduce this format without accessing the
      # registry as follows.  All subtags, including extension and private
      # use subtags, use lowercase letters with two exceptions: two-letter
      # and four-letter subtags that neither appear at the start of the tag
      # nor occur after singletons.  Such two-letter subtags are all
      # uppercase (as in the tags "en-CA-x-ca" or "sgn-BE-FR") and four-
      # letter subtags are titlecase (as in the tag "az-Latn-x-latn").
      #++

      def nicecase!
        @sequence.downcase!
        @sequence.gsub!(/-(?:([a-z\d]{4})|[a-z\d]{2}|[a-z\d]-.*)(?=-|$)/) do |sequence|
          if $1
            sequence = HYPHEN + $1.capitalize
          elsif sequence.size == 3
            sequence.upcase!
          end
          sequence
        end
        nil
      end

      def nicecase
        duplicated = self.dup
        duplicated.nicecase!
        duplicated
      end

      def inspect
        sprintf("#<%s:%#0x %s>", self.class.to_s, self.object_id, self.to_s)
      end

    end
  end
end

# EOF