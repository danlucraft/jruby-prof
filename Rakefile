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
  s.files             = %w(README) + 
                        Dir.glob("{lib/**/*}") + 
                        Dir.glob("{templates/**/*}") + 
                        Dir.glob("{examples/**/*}") + 
                        Dir.glob("{src}/**/*") + 
                        Dir.glob("{test}/**/*")
  s.require_paths     = ["lib"]
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
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
