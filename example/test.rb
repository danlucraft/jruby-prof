
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'jruby-prof'

require File.dirname(__FILE__) + "/pidigits"

compute_pidigits(2000)
compute_pidigits(2000)

s = Time.now
compute_pidigits(2000)
puts "took #{Time.now - s}s without tracing"

s = Time.now
JRubyProf.start
compute_pidigits(2000)
result = JRubyProf.stop

puts "took #{Time.now - s}s with tracing"

JRubyProf.print_flat_text(result, "example/flat.txt")
JRubyProf.print_graph_text(result, "example/graph.txt")
JRubyProf.print_graph_html(result, "example/graph.html")
JRubyProf.print_call_tree(result, "example/call_tree.txt")
JRubyProf.print_tree_html(result, "example/call_tree.html")

