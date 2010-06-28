module Lang #:nodoc:
  module Subtags #:nodoc:
    class Extlang < Subtag

      attr_accessor :macrolanguage,
                    :prefix

      def macro
        Subtags.subtag(:language,macrolanguage)
      end

    end
  end
end

# EOF