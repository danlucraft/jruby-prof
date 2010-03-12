
class JRubyProf
  class TreeHtmlPrinter < AbstractPrinter
    def print_on(output)
      invocation = invocation_set.invocations.first
      total_duration = invocation.to_method.duration
      all_invocations = []
      get_invocations(all_invocations, invocation)
      output.puts TABLE_HEADER
      all_invocations = all_invocations.sort_by {|i| m = i.to_method.duration }.reverse
      all_invocations.each do |inv|
        next if inv.name =~ /CachingCallSite\.stop_tracing/
        next if inv.name =~ /JRubyProf\.stop/
        next if inv.duration < 5
        #next if inv.name == "#"
        c = inv
        parents = []
        while c.parent
          c = c.parent
          parents << c
        end
        parents.reverse.each do |parent_inv|
          print_invocation(output, parent_inv, total_duration, false)
        end
        print_invocation(output, inv, total_duration, true)
        inv.children.each do |child_inv|
          next if child_inv.name =~ /CachingCallSite\.stop_tracing/
          print_invocation(output, child_inv, total_duration, false)
        end
        output.puts <<-HTML
          <tr class="break">
            <td colspan="7"></td>
          </tr>
        HTML
      end
      output.puts TABLE_FOOTER
    end
    
    def get_invocations(arr, invocation)
      arr << invocation
      invocation.children.each do |inv|
        get_invocations(arr, inv)
      end
    end
    
    def print_invocation(output, invocation, total_duration, major_row)
      next if invocation.name =~ /JRubyProf\.stop/
      method = invocation.to_method
      total    = method.duration
      total_pc = (total.to_f/total_duration)*100
      children = method.childrens_duration
      self_    = total - children
      self_pc  = (self_.to_f/total_duration)*100
      calls    = method.count
      name     = method.name
      inv_id   = invocation.id
      template = File.read(File.join(File.dirname(__FILE__), "..", "..", "templates", "graph_row.html.erb"))
      erb = ERB.new(template)
      output.puts(erb.result(binding))
    end
    
    def safe_name(name)
      name.gsub("#", "_inst_").gsub(".", "_stat_")
    end
    
    TABLE_HEADER = <<HTML
    <html>
      <body>
<head>
<style media="all" type="text/css">
    table {
	    border-collapse: collapse;
	    border: 1px solid #CCC;
	    font-family: Verdana, Arial, Helvetica, sans-serif;
	    font-size: 9pt;
	    line-height: normal;
    }

    th {
	    text-align: center;
	    border-top: 1px solid #339;
	    border-bottom: 1px solid #339;
	    background: #CDF;
	    padding: 0.3em;
	    border-left: 1px solid silver;
    }

		tr.break td {
		  border: 0;
	    border-top: 1px solid #339;
			padding: 0;
			margin: 0;
		}

    tr.method td {
			font-weight: bold;
    }

    td {
	    padding: 0.3em;
    }

    td:first-child {
	    width: 190px;
	    }

    td {
	    border-left: 1px solid #CCC;
	    text-align: center;
    }	
  </style>
</head>
<table>
  <tr>
    <th>%total</th>
    <th>%self</th>
    <th>total</th>
    <th>self</th>
    <th>children</th>
    <th>calls</th>
    <th>Name</th>
  </tr>
HTML
    TABLE_FOOTER = <<HTML
</table>
</body>
</html>
HTML
    
  end
end