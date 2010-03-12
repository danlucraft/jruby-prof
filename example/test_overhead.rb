
#$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
#require 'jruby-prof'

def empty_method
end

#puts "method overhead"
#
TIMES = 1000
#
#s = Time.now
#0.upto(TIMES) { empty_method }
#puts "#{TIMES} empty method calls took #{Time.now - s}s without tracing"
#
#JRubyProf.start
#s = Time.now
#0.upto(TIMES) { empty_method }
#JRubyProf.stop
#puts "#{TIMES} empty method calls took #{Time.now - s}s with tracing"


def fib(n)
  a, b = 0, 1
  n.times { a, b = b, a + b }
  b
end

def test_fib
  0.upto(TIMES) { fib(5000) }
end

test_fib

s = Time.now
test_fib
puts "fib took #{Time.now - s}s without tracing"

JRubyProf.start
s = Time.now
test_fib
JRubyProf.stop
puts "fib took #{Time.now - s}s with tracing"
