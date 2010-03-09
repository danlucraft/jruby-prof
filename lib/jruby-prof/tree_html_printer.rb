
module JRubyProf
  class TreeHtmlPrinter < AbstractPrinter
    def print_on(output)
      output.puts TABLE_HEADER
      invocation_set.each do |inv|
        dump_from_root(output, inv)
      end
      output.puts TABLE_FOOTER
    end

    private
    
    def dump(invocation)
      result = <<-HTML
        <li class="closed">
          <span class="path">
            #{ invocation.name }
          </span>
          <span class="count">
            #{ invocation.count }
          </span>
          <span class="duration">
            #{ invocation.duration }
          </span>
          <span class="childrens_duration">
            #{ invocation.childrens_duration }
          </span>
          <ul>
            #{ invocation.children.map {|i| dump(i) }.join("\n") }
          </ul>
        </li>
      HTML
    end
    
    def dump_from_root(f, inv)
      current = inv
      current = current.parent while current.parent
      f.puts(dump(current))
    end
    
    TABLE_HEADER = <<HTML
    <html>
      <body>
<head>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js"></script>
<style media="all" type="text/css">

body {
  width: 1000px;
}

.call-tree {
  font-size: 0.8em;
}

.call-tree li {
  overflow: auto;
  list-style-type: none;
  background-color: rgba(0, 0, 156, 0.075);
  padding: 5px;
  padding-bottom: 1px;
  margin: 5px;
  margin-bottom: 1px;
  border: 1px solid black;
  -webkit-border-radius: 3px;
  clear: both;
}

.call-tree ul {
  width: 350px;  
}

.call-tree ul ul {
  width: 95%;
}

.call-tree .closed>ul {
  display: none;
}

.call-tree ul>li:before {
  float: left;
  width: auto;
  content: "+";
}

.call-tree .count, .call-tree .path {
  width: auto;
}

.call-tree .path {
  float: left;
}

.call-tree .count {
  float: right;
}

.call-tree .open {
  display: block;
}

</style>
</head>
<body>

<script>
  $(document).ready(function() {
    var root = $("li.closed");
    root.click(function (e) { 
      e.stopPropagation();
      $(this).toggleClass("closed"); 
    });
  });
</script>
<div class="call-tree">
HTML
    TABLE_FOOTER = <<HTML
</div>
</body>
</html>
HTML
    
  end
end