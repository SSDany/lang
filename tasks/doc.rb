begin

  begin
    require 'rake/rdoctask'
  rescue LoadError
    abort
  end

  begin
    require 'sdoc'
  rescue LoadError
  end

  desc 'Build RDoc'
  Rake::RDocTask.new(:rdoc) do |rdoc|
    rdoc.rdoc_dir = "doc"
    rdoc.main     = "README.rdoc"
    rdoc.title    = "Lang #{Lang::VERSION} Documentation"
    rdoc.options  << "--charset" << "utf-8" << "--force-update"

    if defined? SDoc
      rdoc.options << "--fmt" << "shtml"
      rdoc.template = "direct"
    else
      rdoc.options << "--line-numbers"
    end

    rdoc.rdoc_files.add FileList['lib/**/*.rb', 'README.rdoc']
  end

  task :clobber => "clobber_rdoc"

rescue LoadError
end

# EOF