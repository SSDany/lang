require 'lang/tag'

module Lang #:nodoc:
  module Tag

    def self.Grandfathered(thing)
      return thing if Grandfathered === thing
      Grandfathered.new(thing)
    end

    # Handles grandfathered registrations.
    #
    class Grandfathered < Composition

      def initialize(thing)
        raise TypeError, "Can't convert #{thing.class} into String" unless thing.respond_to?(:to_str)
        sequence = thing.to_str
        unless Lang::Tag.grandfathered?(sequence)
          raise ArgumentError, "#{sequence.inspect} is not a grandfathered Language-Tag"
        end
        @tag = sequence
      end

      def to_langtag
        unless pr = GRANDFATHERED[@tag.downcase]
          raise Error, "There is no preferred value for the grandfathered Language-Tag #{@tag.inspect}."
        end
        Tag::Langtag(pr)
      end

    end

  end
end

# EOF