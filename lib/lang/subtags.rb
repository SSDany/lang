require 'thread'
require 'lang/subtags/subtag'
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
    Subtag.subclasses.each do |subclass|
      sym = subclass.to_s.gsub(/^.*::/,'').downcase.to_sym
      SYM2CLASS[sym] = subclass
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
      def self.#{sym}(s)
        subtag(:#{sym},s)
      end
      EOS
    end

    @_subtags = {}
    def self.subtag(kind,s)
      return nil unless SYM2CLASS.include?(kind)
      @_subtags[kind] ||= {}
      return @_subtags[kind][s] if @_subtags[kind].key?(s = s.downcase)
      LOCK.synchronize { @_subtags[kind][s] = _load_subtag(kind,s) }
    end

    def self.clear
      LOCK.synchronize { @_subtags.clear }
    end

    def self.close
      LOCK.synchronize {
        _registry.close
        _indices.close
      }
    end

    def self._search(kind,s)
      lower, offset, upper, t, i, r = 0, *_boundaries[kind]
      target = s.ljust(t)
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

    def self._load_subtag(kind,s)
      amount = _search(kind,s)
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

    REGISTRY_PATH = File.join(File.dirname(__FILE__), "data", "language-subtag-registry")

    def self._registry
      @_registry ||= File.open(REGISTRY_PATH, File::RDONLY)
    end

    def self._indices
      @_indices ||= File.open("#{REGISTRY_PATH}.indices", File::RDONLY)
    end

    def self._boundaries
      return @_boundaries if @_boundaries
      _indices.seek(0,IO::SEEK_SET)
      @_boundaries = {}
      Subtag.subclasses.size.times do
        boundary = _indices.readline.split(COLON_SPLITTER)
        @_boundaries[boundary.shift.to_sym] = boundary.map { |b| b.to_i }
      end
      @_boundaries.each { |_,b| b[0] += _indices.pos } #normalize
      @_boundaries
    end

    class << self
      private :_boundaries, :_indices, :_registry
      private :_load_subtag
      private :_search
    end

  end
end

# EOF