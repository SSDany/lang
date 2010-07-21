require 'lang/tag'

module Lang #:nodoc:
  module Tag

    def self.Privateuse(thing)
      return thing if Privateuse === thing
      Privateuse.new(thing)
    end

    # Handles 'privateuse' registrations.
    #
    class Privateuse < Composition

      def initialize(thing)
        raise TypeError, "Can't convert #{thing.class} into String" unless thing.respond_to?(:to_str)
        sequence = thing.to_str
        unless Lang::Tag.privateuse?(sequence)
          raise ArgumentError, "#{sequence.inspect} is not a privateuse Language-Tag"
        end
        super(sequence)
      end

      def nicecase!
        @tag.downcase!
        nil
      end

    end

  end
end

# EOF