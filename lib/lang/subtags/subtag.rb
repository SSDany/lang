module Lang #:nodoc:
  module Subtags #:nodoc:
    class Subtag

      attr_accessor :name,
                    :preferred_value,
                    :added_at,
                    :deprecated_at,
                    :comments

      def deprecated?
        @deprecated_at.nil?
      end

      def description
        @descriptions ? @descriptions.join("\n") : nil
      end

      def add_description(chunk)
        @descriptions ||= []
        @descriptions << chunk
      end

      def self.inherited(subclass)
        subclasses << subclass
      end

      def self.subclasses
        @subclasses ||= []
      end

    end
  end
end

# EOF