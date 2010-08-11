module RBench
  module Reporter

    module Common

      def default(&block)
        block_given? ? @default = block : @default
      end

      def add_reports(*names_and_requisites, &block)
        block = default unless block_given?
        raise LocalJumpError, "block not supplied" unless block
        names_and_requisites.each { |name, *r| block[self, name, *r] }
      end

    end

    # mixin to the RBench::Group
    #
    module Group
      include Common

      def default(&block)
        block_given? ? @default = block : @default || @runner.default
      end

    end

    # mixin to the RBench::Runner
    #
    module Runner
      include Common

      def add_grouped_reports(name, *names_and_requisites, &block)
        group(name)
        item = @items.last
        item.add_reports(*names_and_requisites, &block)
        item.summary ''
      end

      alias :grouped :add_grouped_reports
    end

  end
end

class RBench::Runner
  include RBench::Reporter::Runner
end

class RBench::Group
  include RBench::Reporter::Group
end

# EOF