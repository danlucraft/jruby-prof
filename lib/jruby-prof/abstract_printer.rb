
class JRubyProf
  class AbstractPrinter
    attr_reader :invocation_set
  
    def initialize(invocation_set, options={})
      @invocation_set = invocation_set
      @options = options
    end
    
    def print_to_file(filename)
      puts "Dumping trace to #{File.expand_path(filename)}"
      File.open(filename, "w") do |f|
        print_on(f)
      end
    end
  end
end



