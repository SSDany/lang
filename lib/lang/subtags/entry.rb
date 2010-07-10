module Lang #:nodoc:
  module Subtags
    class Entry

      attr_accessor :name,
                    :preferred_value,
                    :added_at,
                    :deprecated_at,
                    :comments

      def deprecated?
        !@deprecated_at.nil?
      end

      def description
        @descriptions.join("\n") if @descriptions
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

      def self.entries
        @entries ||= {}
      end

    end
  end
end

# EOF