
class JRubyProf
  class AbstractPrinter
    attr_reader :thread_set
  
    def initialize(thread_set, options={})
      @thread_set = thread_set
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



