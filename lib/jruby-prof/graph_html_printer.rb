
module JRubyProf
  class GraphHtmlPrinter < GraphTextPrinter
    def print_on(output)
      methods = invocation_set.get_methods.values.sort_by {|m| m.duration }.reverse
      total_duration = invocation_set.top_level_duration
      output.puts TABLE_HEADER
      rows = methods.map do |method|
        method.parent.each do |context|  
          print_method(output, context, total_duration, false)
        end
        print_method(output, method, total_duration, true)
        method.child_contexts.each do |context|  
          print_method(output, context, total_duration, false)
        end
        output.puts <<-HTML
          <tr class="break">
            <td colspan="7"></td>
          </tr>
        HTML
      end
      output.puts TABLE_FOOTER
    end

    def print_method(output, method, total_duration, major_row)
      return if method.name =~ /JRubyProf\.stop/
      total    = method.duration
      total_pc = (total.to_f/total_duration)*100
      children = method.childrens_duration
      self_    = total - children
      self_pc  = (self_.to_f/total_duration)*100
      calls    = method.count
      name     = method.name
      inv_id   = nil
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
	    border-top: 1px solid #FB7A31;
	    border-bottom: 1px solid #FB7A31;
	    background: #FFC;
	    padding: 0.3em;
	    border-left: 1px solid silver;
    }

		tr.break td {
		  border: 0;
	    border-top: 1px solid #FB7A31;
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