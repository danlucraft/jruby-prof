
module JRubyProf
  class CachingCallSite
    class ProfileInvocation
      alias :method_name  :methodName
      alias :class_name   :className
      alias :static?      :isStatic
    end
  end
end