require 'lang/tag'

module Lang #:nodoc:
  module Tag

    module Lookup

      #--
      # RFC 4647, Section 3.4
      #
      # In the lookup scheme, the language range is progressively truncated
      # from the end until a matching language tag is located.  Single letter
      # or digit subtags (including both the letter 'x', which introduces
      # private-use sequences, and the subtags that introduce extensions) are
      # removed at the same time as their closest trailing subtag.  For
      # example, starting with the range "zh-Hant-CN-x-private1-private2"
      # (Chinese, Traditional script, China, two private-use tags) the lookup
      # progressively searches for content as shown below:
      #
      # Example of a Lookup Fallback Pattern
      #
      # Range to match: zh-Hant-CN-x-private1-private2
      # 1. zh-Hant-CN-x-private1-private2
      # 2. zh-Hant-CN-x-private1
      # 3. zh-Hant-CN
      # 4. zh-Hant
      # 5. zh
      # 6. (default)
      #++

      def lookup_candidates(min_subtags_count = 1)
        subtags = to_a
        return nil if min_subtags_count < 1 || subtags.size < min_subtags_count

        candidates = []
        for i in (min_subtags_count - 1)..(subtags.size - 1) do
          next if subtags[i].size == 1
          candidates.unshift subtags[0..i].join(HYPHEN)
        end
        candidates
      end

    end

    class Composition
      include Lookup
    end

  end
end

# EOF