module Lang #:nodoc:
  module Subtags #:nodoc:
    class Language < Subtag

      attr_accessor :macrolanguage,
                    :suppress_script,
                    :scope

      def macro
        Subtags.subtag(:language,macrolanguage)
      end

    end
  end
end

# EOF