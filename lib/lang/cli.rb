require 'thor' unless defined?(Thor)
require 'lang/subtags'
require 'net/http'
require 'tempfile'

module Lang #:nodoc:
  class Cli < Thor

    class_option :quiet, :type => :boolean, :aliases => '-q', :desc => 'Run command queitly.'

    desc 'index [options]', 'Prepare lang to use a language-subtag-registry.'
    method_option :update, :type => :boolean, :aliases => '-u', :desc => 'Update registry.'

    def index(path = Lang::Subtags.registry_path)
      @path = File.expand_path(path)
      if !exists? || options.update?
        download 'http://www.iana.org/assignments/language-subtag-registry'
      end
      build_indices
    end

    NAME_REGEX = /^(?:#{Subtags::SUBTAG}|#{Subtags::TAG}):\s*([\w-]+)\s*$/io.freeze
    TYPE_REGEX = /^#{Subtags::TYPE}:\s*(\w+)\s*$/io.freeze

    private

    def exists?
      File.exists?("#{@path}.registry")
    end

    def download(uri)
      FileUtils.mkdir_p(File.dirname(@path)) unless exists?
      write("registry") { |temp| http(uri) { |chunk| temp << chunk }}
    end

    def build_indices
      return false unless exists?

      say "Building indices"
      calculate_indices
      calculate_boundaries

      write("indices") do |temp|
        @boundaries.each do |boundary|
          template = "%-#{boundary[-2]}s%#{boundary[-1] - boundary[-2] - 1}d\n"
          @indices[boundary.first].to_a.sort.each { |k,v| temp << template % [k,v] }
        end
      end

      write("boundaries") do |temp|
        @boundaries.each do |boundary|
          temp << "#{boundary.join(":")}\n"
        end
      end

      say "Done"
      true
    end

    private

    def say(*args)
      super unless options.quiet?
    end

    def write(dest, &block)

      path = "#{@path}.#{dest}"
      temp = Tempfile.new(dest)
      temp.binmode
      yield(temp) if block_given?
      temp.close

      # somewhat stolen from ActiveSupport

      begin
        old = File.stat(path)
      rescue Errno::ENOENT
        check = File.join(File.dirname(path), ".permissions_check.#{Thread.current.object_id}.#{Process.pid}.#{rand(1000000)}")
        File.open(check, File::WRONLY | File::CREAT) { }
        old = File.stat(check)
        File.unlink(check)
      end

      FileUtils.mv(temp.path, "#{@path}.#{dest}")

      File.chown(old.uid, old.gid, path)
      File.chmod(old.mode, path)
      nil
    end

    def http(uri)
      say "Downloading #{uri}"
      Net::HTTP.get_response(URI(uri)) do |response|
        total, size = response['Content-Length'].to_i, 0
        response.read_body do |chunk|
          size += chunk.size
          yield(chunk) if block_given?
          say "\r%d%% done (%d of %d)" % [size*100/total, size, total], nil, false
          STDOUT.flush unless options.quiet?
        end
      end
      say "\n"
      nil
    end

    def calculate_boundaries
      calculate_indices unless @indices
      offset = 0
      @boundaries = @indices.keys.sort{ |a,b| a.to_s <=> b.to_s }.map do |kind|
        segment   = @indices[kind]
        boundary  = []
        boundary << kind
        boundary << offset
        boundary << segment.size - 1
        boundary << segment.keys.map{ |s| s.size }.max
        boundary << segment.values.max.to_s.size + boundary.last + 1
        offset   += segment.size * boundary.last
        boundary
      end
      true
    end

    def calculate_indices
      count = 0
      kind, name = nil, nil
      @indices = {}
      File.open("#{@path}.registry", File::RDONLY) do |f|
        f.each_line do |l|
          if TYPE_REGEX === l
            kind = $1.to_sym
            @indices[kind] ||= {}
          elsif kind && NAME_REGEX === l
            name = $1.downcase
            @indices[kind][name] = count
          elsif l == Subtags::SEPARATOR
            kind, name = nil, nil
          end
          count += l.size
        end
      end
      #STDOUT << "#{count}\n"
      true
    end

  end
end