require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"

spec = Gem::Specification.new do |s|
  s.name              = "jruby-prof"
  s.version           = "0.1.0"
  s.summary           = "A Ruby level profiler for JRuby"
  s.author            = "Daniel Lucraft"
  s.email             = "dan@fluentradical.com"
  s.homepage          = "http://danlucraft.com/blog"
  s.has_rdoc          = false
  s.files             = %w(graph.html README tracing_example.html tracing_example.txt) + Dir.glob("{lib/**/*}") + Dir.glob("{templates/**/*}")
  s.require_paths     = ["lib"]
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec

  # Generate the gemspec file for github.
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

# Generate documentation
Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
