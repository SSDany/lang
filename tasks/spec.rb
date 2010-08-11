begin

  namespace :spec do

    require 'spec/rake/spectask'

    JRUBY = RUBY_PLATFORM =~ /java/

    require 'zlib'

    task :prepare do
      target = ROOT + 'spec/data/language-subtag'
      if %w(indices boundaries registry).any? { |ext| !File.exists?("#{target}.#{ext}") }
        File.open("#{target}.gzip", File::RDONLY) do |source|
          gz = Zlib::GzipReader.new(source)
          File.open("#{target}.registry", File::WRONLY | File::CREAT) { |f| f.write gz.read }
          gz.close
        end
        Dir.chdir(ROOT) { `bin/lang reindex #{target}` }
      end
    end

    def run_spec(name, files, rcov)
      Spec::Rake::SpecTask.new(name => 'spec:prepare') do |t|
        t.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
        t.spec_files = Pathname.glob(ENV['FILES'] || files.to_s).map{|f| f.to_s}
        t.rcov = rcov && !JRUBY
        t.rcov_opts << '--exclude' << 'spec' << '--exclude' << 'gems'
        t.rcov_opts << '--text-report'
        t.rcov_opts << '--sort' << 'coverage' << '--sort-reverse'
        t.rcov_dir = 'coverage'
      end
    end

    begin
      desc 'Run specifications with RCov'
      run_spec(:rcov, ROOT + 'spec/**/*_spec.rb', true)
    rescue LoadError
      abort 'rcov not installed'
    end

  end

  desc 'Run specifications'
  run_spec(:spec, ROOT + 'spec/**/*_spec.rb', false)

  task :clobber => "spec:clobber_rcov" if Rake::Task.task_defined? 'spec:clobber_rcov'

rescue LoadError
  abort 'rspec not installed'
end

# EOF