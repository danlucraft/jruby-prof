
module JRubyProf
  class SimpleTreePrinter < AbstractPrinter
    def print_on(output)
      invocation_set.each do |inv|
        dump_from_root(output, inv)
      end
    end
    
    private
    
    def dump(f, inv, indent=0)
      f.print(" "*indent)
      f.puts "#{inv.class_name}#{inv.static? ? "." : "#"}#{inv.method_name}:#{inv.duration}"
      inv.children.each {|child_inv| dump(f, child_inv, indent + 2)}
    end
    
    def dump_from_root(f, inv)
      current = inv
      current = current.parent while current.parent
      dump(f, current)
    end
  end
end