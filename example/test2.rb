require 'java'
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'jruby-prof'

import org.jruby.prof.JRubyProf
JRubyProf.printHello



class Thing
  def foo(a, b)
    a + b
  end
  
  def self.bar(a, b)
    a * b
  end
end
JRubyProf.start
  
thing = Thing.new
thing.foo(1, 2)
Thing.bar(1, 2)
JRubyProf.stop
JRubyProf.print_flat_text("flat.txt")
JRubyProf.print_graph_text("graph.txt")
JRubyProf.print_graph_html("graph.html")
JRubyProf.print_call_tree("call_tree.txt")
JRubyProf.print_tree_html("call_tree.html")
