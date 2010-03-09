
module JRubyProf
  class FlatTextPrinter < AbstractPrinter
    TABLE_HEADER = " %self  cumulative    total     self   children    calls self/call total/call  name"  
    def print_on(output)
      methods = invocation_set.get_methods.values.sort_by {|m| m.duration }.reverse
      output.puts TABLE_HEADER
      total_duration = 0
      rows = methods.map do |method|
        total    = method.duration
        children = method.childrens_duration
        self_    = total - children
        total_duration += self_ unless self_ < 0
        next if method.name == "#"
        [total, children, self_, method.count, method.name]
      end
      cumulative = 0
      rows = rows.compact.sort_by {|r| r[2]}.reverse
      rows.each do |row|
        total, children, self_, count, name = *row
        cumulative += self_
        self_pc = (self_.to_f/total_duration)*100
        self_per_call = self_.to_f/count
        total_per_call = total.to_f/count
        output.puts "#{("%2.2f" % self_pc).rjust(6)} #{cumulative.to_s.rjust(11)} #{total.to_s.rjust(8)}  #{self_.to_s.rjust(7)}  #{children.to_s.rjust(8)}   #{count.to_s.rjust(7)} #{("%2.2f" % self_per_call).to_s.rjust(9)} #{("%2.2f" % total_per_call).to_s.rjust(10)}  #{name}"
      end
    end
  end
end