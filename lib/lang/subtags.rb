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
      def self.#{meth}(s)
        entry(:#{kind},s)
      end
      EOS
    end

    def self.entry(kind, snippet)
      return nil unless SYM2CLASS.include?(kind)
      klass = SYM2CLASS[kind]
      LOCK.synchronize {
        if klass.entries.key?(snippet) ||
           klass.entries.key?(snippet = snippet.downcase)
          return klass.entries[snippet]
        end
        klass.entries[snippet] = _load_entry(kind, snippet)
      }
    end

    def self.close
      LOCK.synchronize {
        _registry.close
        _indices.close
      }
    end

    def self._search(kind, snippet)
      lower, offset, upper, t, i, r = 0, *_boundaries[kind]
      target = snippet.ljust(t)
      until upper < lower
        middle = (lower+upper)/2
        _indices.seek(offset + middle*r, IO::SEEK_SET)
        value = _indices.read(t)
        if value == target
          return _indices.read(i).to_i
        elsif target < value
          upper = middle-1
        else
          lower = middle+1
        end
      end
      nil
    end

    def self._load_entry(kind, snippet)
      amount = _search(kind, snippet)
      return nil unless amount
      _registry.seek(amount, IO::SEEK_SET)
      thing = SYM2CLASS[kind].new
      until _registry.readline == SEPARATOR

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

    REGISTRY_PATH = File.join(File.dirname(__FILE__), "data", "language-subtags")

    def self._registry
      @_registry ||= File.open("#{REGISTRY_PATH}.registry", File::RDONLY)
    end

    def self._indices
      @_indices ||= File.open("#{REGISTRY_PATH}.indices", File::RDONLY)
    end

    def self._boundaries
      return @_boundaries if @_boundaries
      @_boundaries = {}
      File.open("#{REGISTRY_PATH}.boundaries", File::RDONLY).each_line do |line|
        boundary = line.split(COLON_SPLITTER)
        @_boundaries[boundary.shift.to_sym] = boundary.map { |b| b.to_i }
      end
      @_boundaries
    end

    class << self
      private :_boundaries, :_indices, :_registry
      private :_load_entry
      private :_search
    end

  end
end

# EOF