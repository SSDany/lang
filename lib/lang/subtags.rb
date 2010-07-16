require 'thread'
require 'lang/subtags/entry'
require 'lang/subtags/language'
require 'lang/subtags/extlang'
require 'lang/subtags/script'
require 'lang/subtags/region'
require 'lang/subtags/variant'
require 'lang/subtags/grandfathered'
require 'lang/subtags/redundant'

module Lang #:nodoc:
  module Subtags

    LOCK            = Mutex.new
    SEPARATOR       = "%%\n".freeze
    TYPE            = "Type".freeze
    SUBTAG          = "Subtag".freeze
    TAG             = "Tag".freeze
    ADDED           = "Added".freeze
    DEPRECATED      = "Deprecated".freeze
    DESCRIPTION     = "Description".freeze
    COMMENTS        = "Comments".freeze
    PREFIX          = "Prefix".freeze
    PREFERRED_VALUE = "Preferred-Value".freeze
    MACROLANGUAGE   = "Macrolanguage".freeze
    SCOPE           = "Scope".freeze
    SUPPRESS_SCRIPT = "Suppress-Script".freeze
    CONTINUE_REGEX  = /\A\s\s/.freeze

    COLON           = ":".freeze
    COLON_SPLITTER  = RUBY_VERSION < '1.9.1' ? /\:/.freeze : COLON

    SYM2CLASS = {}
    Entry.subclasses.each do |subclass|
      meth = subclass.to_s.gsub(/^.*::/,'')
      kind = meth.downcase.to_sym
      SYM2CLASS[kind] = subclass
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
      def #{meth}(s)
        entry(:#{kind},s)
      end
      EOS
    end

    def entry(kind, snippet)
      return nil unless SYM2CLASS.include?(kind)
      klass = SYM2CLASS[kind]
      LOCK.synchronize {
        if klass.entries.key?(snippet) ||
           klass.entries.key?(snippet = snippet.downcase)
          return klass.entries[snippet]
        end
        klass.entries[snippet] = load_entry(kind, snippet)
      }
    end

    def close
      LOCK.synchronize {
        registry.close
        indices.close
      }
    end

    def search(kind, snippet)

      lower = 0
      offset, upper, t, r = *boundaries[kind]
      target = snippet.ljust(t)

      until upper < lower
        middle = (lower+upper)/2
        indices.seek(offset + middle*r, IO::SEEK_SET)
        value = indices.read(t)
        if value == target
          return indices.read(r-t).to_i
        elsif target < value
          upper = middle-1
        else
          lower = middle+1
        end
      end
      nil
    end

    def load_entry(kind, snippet)
      amount = search(kind, snippet)
      return nil unless amount
      registry.seek(amount, IO::SEEK_SET)
      thing = SYM2CLASS[kind].new
      until registry.eof? || registry.readline == SEPARATOR

        line = $_
        thing.comments << $' && next if CONTINUE_REGEX === line
        attribute, value = line.split(COLON_SPLITTER,2)
        value.strip!

        case attribute
        when DESCRIPTION      ; thing.add_description(value)
        when PREFIX           ; kind == :variant ? thing.add_prefix(value) : thing.prefix = value
        when SUBTAG,TAG       ; thing.name            = value
        when ADDED            ; thing.added_at        = value
        when DEPRECATED       ; thing.deprecated_at   = value
        when COMMENTS         ; thing.comments        = value
        when PREFERRED_VALUE  ; thing.preferred_value = value
        when MACROLANGUAGE    ; thing.macrolanguage   = value
        when SCOPE            ; thing.scope           = value
        when SUPPRESS_SCRIPT  ; thing.suppress_script = value
        end

      end
      thing
    end

    def registry_path
      @registry_path ||= File.join(File.dirname(__FILE__), "data", "language-subtags")
    end

    def registry
      @registry ||= File.open("#{registry_path}.registry", File::RDONLY)
    end

    def indices
      @indices ||= File.open("#{registry_path}.indices", File::RDONLY)
    end

    def boundaries
      return @boundaries if @boundaries
      @boundaries = {}
      File.open("#{registry_path}.boundaries", File::RDONLY).each_line do |line|
        boundary = line.split(COLON_SPLITTER)
        @boundaries[boundary.shift.to_sym] = boundary.map { |b| b.to_i }
      end
      @boundaries
    end

    extend self

    class << self
      private :boundaries, :indices, :registry
      private :load_entry
      private :search
    end

  end
end

# EOF