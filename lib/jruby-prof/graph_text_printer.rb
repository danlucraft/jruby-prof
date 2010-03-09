
module JRubyProf
  class GraphTextPrinter < AbstractPrinter
    TABLE_HEADER = " %total    %self      total      self    children    calls   Name"
    
    def print_on(output)
      methods = invocation_set.get_methods.values.sort_by {|m| m.duration }.reverse
      output.puts TABLE_HEADER
      output.puts "-"*100
      total_duration = invocation_set.top_level_duration
      rows = methods.map do |method|
        method.parent_contexts.each do |context|  
          print_method(output, context, total_duration, false)
        end
        print_method(output, method, total_duration, true)
        method.child_contexts.each do |context|  
          print_method(output, context, total_duration, false)
        end
        output.puts "-"*100
      end
    end
    
    def print_method(output, method, total_duration, print_percents)
      return if method.name =~ /JRubyProf\.stop/
      total    = method.duration
      total_pc = (total.to_f/total_duration)*100
      children = method.childrens_duration
      self_    = total - children
      self_pc  = (self_.to_f/total_duration)*100
      calls    = method.count
      name     = method.name
      if print_percents
        output.print " #{("%2.2f" % total_pc).rjust(6)}% #{("%2.2f" % self_pc).rjust(6)}%"
      else
        output.print "                "
      end
      output.puts "#{total.to_s.rjust(11)} #{self_.to_s.rjust(9)} #{children.to_s.rjust(11)} #{calls.to_s.rjust(8)}  #{name}"
    end
  end
end