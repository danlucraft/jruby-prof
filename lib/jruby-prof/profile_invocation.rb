
module JRubyProf
  class CachingCallSite
    class ProfileInvocation
      alias :method_name  :methodName
      alias :class_name   :className
      alias :static?      :isStatic
      
      def name
        "#{class_name}#{static? ? "." : "#"}#{method_name}"
      end
    end
  end
end