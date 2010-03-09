
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'jruby-prof'

class Thing
  def stuff1
    10000.times { 1 + 2 }
  end
  
  def stuff2
    "asdf".length
  end
  
  def stuff3
    10000.times { stuff2 }
  end
  
  def method_overhead
  end
  
  def stuff4
    10000.times { method_overhead }
  end
end


thing = Thing.new
JRubyProf.start_tracing
thing.stuff1
thing.stuff3
thing.stuff4
JRubyProf.stop_tracing
JRubyProf.print_flat_text("tracing_example.txt")
