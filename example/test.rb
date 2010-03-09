
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'jruby-prof'

class Thing
  def stuff1
    10000.times { 1 + 2; "asdf".length }
  end
  
  def length
    "asdf".length
  end
  
  def stuff4
    10000.times { length }
  end
end


thing = Thing.new
s = Time.now
JRubyProf.start
thing.stuff1
thing.stuff4
JRubyProf.stop
puts "took #{Time.now - s}s"
JRubyProf.print_graph_text("tracing_example.txt")
