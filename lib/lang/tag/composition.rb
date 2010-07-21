module Lang #:nodoc:
  module Tag
    class Composition

      def initialize(sequence)
        @tag = sequence
      end

      # Returns +true+ if language-tags are equal.
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

      def composition
        @composition ||= to_s.downcase
      end

      def to_s
        @tag
      end

      alias :to_str :to_s

      def to_a
        to_s.split(HYPHEN)
      end

      def decomposition
        @decomposition ||= composition.split(HYPHEN_SPLITTER)
      end

      private :decomposition

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

      def nicecase!
        raise NotImplementedError
      end

      def nicecase
        duplicated = self.dup
        duplicated.nicecase!
        duplicated
      end

    end
  end
end

# EOF