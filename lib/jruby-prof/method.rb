
module JRubyProf
  class Method
    attr_reader :class_name, :method_name, :invocations
  
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
      invocations << inv
    end
    
    def duration
      if toplevel?
        childrens_duration
      else
        invocations.inject(0) {|m, inv| m + inv.duration}
      end
    end
    
    def count
      if toplevel?
        1
      else
        invocations.inject(0) {|m, inv| m + inv.count}
      end
    end
    
    def childrens_duration
      invocations.inject(0) {|m, inv| m + inv.children.inject(0) {|m1, inv1| m1 + inv1.duration }}
    end
    
    def name
      "#{class_name}#{static? ? "." : "#"}#{method_name || "toplevel"}"
    end
    
    class CallContext
      attr_accessor :name, :duration, :childrens_duration, :count
      
      def toplevel?
        @name == "#"
      end
      
      def name
        toplevel? ? "#toplevel" : @name
      end
    
      def initialize(name)
        @name = name
        @duration, @childrens_duration, @count = 0, 0, 0
      end
      
      def duration
        toplevel? ? @childrens_duration : @duration
      end
    end
    
    def child_contexts
      @child_contexts ||= begin
        h = {}
        invocations.each do |inv| 
          inv.children.each do |inv2|
            h[inv2.name] ||= CallContext.new(inv2.name)
            cc = h[inv2.name]
            cc.duration           += inv2.duration
            cc.childrens_duration += inv2.childrens_duration
            cc.count              += inv2.count
          end
        end
        h.values
      end
    end
    
    def parent_contexts
      @parent_contexts ||= begin
        h = {}
        invocations.each do |inv| 
          inv2 = inv.parent
          next unless inv2
          h[inv2.name] ||= CallContext.new(inv2.name)
          cc = h[inv2.name]
          cc.duration           += inv.duration
          cc.childrens_duration += inv.childrens_duration
          cc.count              += inv.count
        end
        h.values
      end
    end
  end
end



