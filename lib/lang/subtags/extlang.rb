module Lang #:nodoc:
  module Subtags
    # Holds data about extlang subtags.
    class Extlang < Entry

      attr_accessor :macrolanguage,
                    :suppress_script,
                    :prefix,
                    :scope

      def macro
        Subtags.entry(:language, macrolanguage) if macrolanguage
      end

    end
  end
end

# EOF