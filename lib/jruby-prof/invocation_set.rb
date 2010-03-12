
class JRubyProf
  class InvocationSet
    attr_reader :invocations
  
    def initialize(invocations)
      @invocations = invocations.map do |inv|
        c = inv
        c = c.parent while c.parent
        c
      end
    end
    
    def get_methods
      h = {}
      invocations.each do |inv|
        InvocationSet.add_methods(h, inv)
      end
      h
    end
    
    def length
      invocations.length
    end
    
    def top_level_duration
      invocations.inject(0.0) do |m, inv| 
        m + inv.childrens_duration
      end
    end
    
    def self.add_methods(h, inv, duration=nil, count=nil)
      return if inv.name =~ /CachingCallSite\.stop_tracing/ or inv.name =~ /JRubyProf\.stop/
      h[inv.name] ||= Method.new(inv.class_name, inv.method_name, inv.static?)
      h[inv.name].add_invocation(inv)
      inv.children.each do |child_inv|
        add_methods(h, child_inv)
      end
    end
  end
end