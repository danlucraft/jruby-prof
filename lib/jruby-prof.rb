
require 'java'
require 'erb'

require File.dirname(__FILE__) + "/../dist/lib/jruby-prof.jar"

import org.jruby.prof.JRubyProf


require 'jruby-prof/abstract_printer'
require 'jruby-prof/simple_tree_printer'
require 'jruby-prof/flat_text_printer'
require 'jruby-prof/graph_text_printer'
require 'jruby-prof/graph_html_printer'
require 'jruby-prof/invocation_set'
require 'jruby-prof/method'
require 'jruby-prof/tree_html_printer'

require 'jruby-prof/profile_invocation'

class JRubyProf
  
  def self.start
    raise RuntimeError, "JRubyProf already running" if running?
    start_tracing
  end
  
  def self.stop
    stop_tracing
  end
  
  def self.running?
    self.is_running
  end
  
  def self.profile
    raise ArgumentError, "profile requires a block" unless block_given?
    start
    yield
    stop
  end
  
  def self.print_call_tree(result, filename)
    printer = SimpleTreePrinter.new(ThreadSet.new(result.values.to_a, JRubyProf.lastTracingDuration))
    printer.print_to_file(filename)
  end
  
  def self.print_tree_html(result, filename)
    printer = TreeHtmlPrinter.new(ThreadSet.new(result.values.to_a, JRubyProf.lastTracingDuration))
    printer.print_to_file(filename)
  end
  
  def self.print_flat_text(result, filename)
    printer = FlatTextPrinter.new(ThreadSet.new(result.values.to_a, JRubyProf.lastTracingDuration))
    printer.print_to_file(filename)
  end
  
  def self.print_graph_text(result, filename)
    printer = GraphTextPrinter.new(ThreadSet.new(result.values.to_a, JRubyProf.lastTracingDuration))
    printer.print_to_file(filename)
  end

  def self.print_graph_html(result, filename)
    printer = GraphHtmlPrinter.new(ThreadSet.new(result.values.to_a, JRubyProf.lastTracingDuration))
    printer.print_to_file(filename)
  end
end