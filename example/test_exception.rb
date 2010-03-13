require 'java'
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'jruby-prof'

class Thing
  def self.foo(a, b)
    begin
      Thing2.bar(a, b)
    rescue
    end
  end
end

class Thing2
  def self.bar(a, b)
    raise "foo"
  end
end

result = JRubyProf.profile do
  1.times { Thing.foo(1, 2) }
end

JRubyProf.print_flat_text(result, "flat.txt")
JRubyProf.print_graph_text(result, "graph.txt")
JRubyProf.print_graph_html(result, "graph.html")
JRubyProf.print_call_tree(result, "call_tree.txt")
JRubyProf.print_tree_html(result, "call_tree.html")
