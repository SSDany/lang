def run_benchmarks(name,pattern)
  task name do
    Dir[ROOT.join(pattern).to_s].each { |file| system "ruby #{file}"; STDOUT << "\n" }
  end
end

namespace :benchmarks do

  desc "Bench lang against other tools"
  run_benchmarks(:vs, 'benchmarks/vs/*_bench.rb')

  namespace :vs do
    Dir[ROOT.join('benchmarks/vs/*_bench.rb').to_s].
    map{ |file| File.basename(file)[/vs_([a-z\d]+?)_.*/,1] }.uniq.each do |tool|
      desc "Bench lang against #{tool}"
      run_benchmarks(tool, "benchmarks/vs/vs_{#{tool},#{tool}_*}_bench.rb")
    end
  end

end

desc "Run benchmarks"
run_benchmarks(:benchmarks, 'benchmarks/**/*_bench.rb')

# EOF