
module JRubyProf
  class Method
    attr_reader :class_name, :method_name
  
    def initialize(class_name, method_name, static)
      @class_name, @method_name, @static = class_name, method_name, static
      @invocations = []
    end
    
    def static?
      @static
    end
    
    def toplevel?
      method_name == nil
    end
    
    def add_invocation(inv)
      @invocations << inv
    end
    
    def duration
      if toplevel?
        childrens_duration
      else
        @invocations.inject(0) {|m, inv| m + inv.duration}
      end
    end
    
    def count
      if toplevel?
        1
      else
        @invocations.inject(0) {|m, inv| m + inv.count}
      end
    end
    
    def childrens_duration
      @invocations.inject(0) {|m, inv| m + inv.children.inject(0) {|m1, inv1| m1 + inv1.duration }}
    end
    
    def name
      "#{class_name}#{static? ? "." : "#"}#{method_name || "toplevel"}"
    end
  end
end