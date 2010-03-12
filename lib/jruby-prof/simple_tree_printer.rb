
class JRubyProf
  class SimpleTreePrinter < AbstractPrinter
    def print_on(output)
      thread_set.invocations.each_with_index do |invocation, i|
        output.puts 
        output.puts "*** Thread #{i + 1} / #{thread_set.length}"
        output.puts 
        dump_from_root(output, invocation)
      end
    end
    
    private
    
    def dump(f, inv, indent=0)
      f.print(" "*indent)
      f.puts "#{inv.name}:#{inv.duration}"
      inv.children.each {|child_inv| dump(f, child_inv, indent + 2)}
    end
    
    def dump_from_root(f, inv)
      current = inv
      current = current.parent while current.parent
      dump(f, current)
    end
  end
end