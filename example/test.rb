
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
  
  def stuff5
    begin
      stuff6
    rescue
      p :foo
    end
    1*4
  end
  
  def stuff6
    p :ad
    foo
    p :fg
  end
end


thing = Thing.new
s = Time.now
JRubyProf.start
require 'rubygems'
#thing.stuff1
#thing.stuff5
JRubyProf.stop
puts "took #{Time.now - s}s"
JRubyProf.print_call_tree("tracing_example.txt")
JRubyProf.print_tree_html("tracing_example.html")
