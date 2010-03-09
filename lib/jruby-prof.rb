
require 'java'

require 'jruby-prof/abstract_printer'
require 'jruby-prof/simple_tree_printer'
require 'jruby-prof/invocation_set'

module JRubyProf
  import org.jruby.runtime.callsite.CachingCallSite

  require 'jruby-prof/profile_invocation'

  def self.start_tracing
    org.jruby.runtime.callsite.CachingCallSite.start_tracing
  end
  
  def self.stop_tracing
    org.jruby.runtime.callsite.CachingCallSite.stop_tracing
  end
  
  def self.print_call_tree(filename)
    printer = SimpleTreePrinter.new(org.jruby.runtime.callsite.CachingCallSite.currentInvocations.values)
    printer.print_to_file(filename)
  end
end