begin

  begin
    require 'hanna/rdoctask'
  rescue LoadError
    require 'rake/rdoctask'
  end

  desc 'Build RDoc'
  Rake::RDocTask.new(:rdoc) do |rdoc|
    rdoc.rdoc_dir = "doc"
    rdoc.main     = "README.rdoc"
    rdoc.title    = "Lang #{Lang::VERSION} Documentation"
    rdoc.options  << "--charset" << "utf-8" << "--force-update" << "--line-numbers"
    rdoc.rdoc_files.add FileList['lib/**/*.rb', 'README.rdoc']
  end

  task :clobber => "clobber_rdoc"

rescue LoadError
end

# EOF