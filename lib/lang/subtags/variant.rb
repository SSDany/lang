module Lang #:nodoc:
  module Subtags #:nodoc:
    class Variant < Subtag

      attr_accessor :prefixes

      def allows_prefix?(prefix)
        @prefixes && @prefixes.include?(prefix)
      end

      def add_prefix(prefix)
        @prefixes ||= []
        @prefixes << prefix
      end

    end
  end
end

# EOF