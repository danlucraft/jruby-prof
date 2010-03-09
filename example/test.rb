
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'jruby-prof'

class Thing
  def stuff1
    10000.times { 1 + 2 }
  end
  
  def method_overhead
  end
  
  def stuff4
    10000.times { method_overhead }
  end
end


thing = Thing.new
s = Time.now
JRubyProf.start
thing.stuff1
thing.stuff4
JRubyProf.stop
puts "took #{Time.now - s}s"
JRubyProf.print_flat_text("tracing_example.txt")
