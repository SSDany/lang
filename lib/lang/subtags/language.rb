module Lang #:nodoc:
  module Subtags
    # Holds data about primary language subtags.
    class Language < Entry

      attr_accessor :macrolanguage,
                    :suppress_script,
                    :scope

      def macro
        Subtags.entry(:language, macrolanguage) if macrolanguage
      end

    end
  end
end

# EOF