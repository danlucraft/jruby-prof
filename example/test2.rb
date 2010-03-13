require 'rubygems'
require 'jruby-prof'

class Thing
  def self.foo(a, b)
    a + b
  end
end

class Thing2
  def self.bar(a, b)
    a * b
  end
end

result = JRubyProf.profile do
  Thread.new do 
    100.times {
      Thing.foo(1, 2)
    }
  end
  100.times { Thing2.bar(1, 2) }
end

JRubyProf.print_flat_text(result, "flat.txt")
JRubyProf.print_graph_text(result, "graph.txt")
JRubyProf.print_graph_html(result, "graph.html")
JRubyProf.print_call_tree(result, "call_tree.txt")
JRubyProf.print_tree_html(result, "call_tree.html")
