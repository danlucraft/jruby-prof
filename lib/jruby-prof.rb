
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
  
  def self.print_call_tree(filename)
    printer = SimpleTreePrinter.new(JRubyProf.currentInvocations.values)
    printer.print_to_file(filename)
  end
  
  def self.print_tree_html(filename)
    printer = TreeHtmlPrinter.new(InvocationSet.new(JRubyProf.currentInvocations.values.to_a))
    printer.print_to_file(filename)
  end
  
  def self.print_flat_text(filename)
    printer = FlatTextPrinter.new(InvocationSet.new(JRubyProf.currentInvocations.values.to_a))
    printer.print_to_file(filename)
  end
  
  def self.print_graph_text(filename)
    printer = GraphTextPrinter.new(InvocationSet.new(JRubyProf.currentInvocations.values.to_a))
    printer.print_to_file(filename)
  end

  def self.print_graph_html(filename)
    printer = GraphHtmlPrinter.new(InvocationSet.new(JRubyProf.currentInvocations.values.to_a))
    printer.print_to_file(filename)
  end
end