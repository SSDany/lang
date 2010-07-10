module Lang #:nodoc:
  module Subtags
    # Holds data about variant subtags.
    class Variant < Entry

      attr_reader :prefixes

      def add_prefix(prefix)
        @prefixes ||= []
        @prefixes << prefix
      end

    end
  end
end

# EOF