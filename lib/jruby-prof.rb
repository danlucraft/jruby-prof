
require 'java'

module JRubyProf
  def self.start_tracing
    org.jruby.runtime.callsite.CachingCallSite.start_tracing
  end
  
  def self.stop_tracing
    org.jruby.runtime.callsite.CachingCallSite.stop_tracing
  end
  
  def self.dump(f, inv, indent=0)
    f.print(" "*indent)
    f.puts "#{inv.className}#{inv.isStatic ? "." : "#"}#{inv.methodName}:#{inv.duration}"
    inv.children.each {|child_inv| dump(f, child_inv, indent + 2)}
  end
  
  def self.dump_from_root(f, inv)
    current = inv
    current = current.parent while current.parent
    dump(f, current)
  end
      
  def self.print_call_tree(filename)
    puts "Dumping trace to #{File.expand_path(filename)}"
    File.open(filename, "w") do |f|
      org.jruby.runtime.callsite.CachingCallSite.currentInvocations.each do |context, inv|
        dump_from_root(f, inv)
      end
    end
  end
end