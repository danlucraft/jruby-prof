
module JRubyProf
  class InvocationSet
    attr_reader :invocations
  
    def initialize(invocations)
      @invocations = invocations
    end
  end
end