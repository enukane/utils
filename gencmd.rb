#!/usr/bin/env ruby

# gencmd.rb -o outputpath <opts>
#   opts := ( OPTCHAR [ ":" ] )+

require "erb"
require "optparse"
require "fileutils"

TEMPLATE=<<'EOF'
#!/usr/bin/env ruby
require "optparse"

OPTS={
  # XXX: put default value here
}
opt = OptionParser.new

<%- OPTIONS.each do |option| -%>
  <%- if option[:arg] == true -%>
opt.on("-<%= option[:symbol] %> VAL", "--<%= option[:symbol] %>==VAL") {|v|
  # XXX: implement
  OPTS[:<%= option[:symbol] %>] = v
}
  <%- else -%>
opt.on("-<%= option[:symbol] %>", "--<%= option[:symbol] %>") {|v|
  # XXX: implement
  OPTS[:<%= option[:symbol] %>] = true
}
  <%- end -%>
<%- end -%>

(class<<self;self;end).module_eval do
  define_method(:usage) do |msg|
    puts opt.to_s
    puts "error: #{msg}" if msg
    exit 1
  end
end

begin
  rest = opt.parse(ARGV)
  # XXX: this forbids option-less argument
  if rest.length != 0
    usage nil
  end
rescue
  usage $!.to_s
end

$debug = false

def dp str
  if $debug
    p str
  end
end

# XXX: implement logic here
p "OPTS = #{OPTS}"
raise "main: unimplemented"
EOF

opt = OptionParser.new
OPTS = {
  :output => nil,
}

opt.on("-o PATH", "--output=PATH") {|v|
  OPTS[:output] = v
}


(class<<self;self;end).module_eval do
  define_method(:usage) do |msg|
    puts opt.to_s
    puts "error: #{msg}" if msg
    exit 1
  end
end

symbols = nil
begin
  rest = opt.parse(ARGV)
  # XXX: this forbids option-less argument
  if rest.length != 1
    usage nil
  end
  symbols = rest[0]
rescue
  usage $!.to_s
end

opts_with_arg = symbols.scan(/.:/).map{|c| c.gsub(/:/, "")}
opts = symbols.gsub(/:/, "").split("")

OPTIONS = []
opts.each do |c|
  OPTIONS << {
    :symbol => c,
    :arg => (opts_with_arg.include?(c)),
  }
end


str = ERB.new(TEMPLATE, trim_mode: "-").result

if OPTS[:output].nil?
  puts str
  STDERR.puts "✅: output to stdout"
  exit(0)
end

File.open(OPTS[:output], "w") do |f|
  f.write str
end
puts "✅: output to '#{OPTS[:output]}"

FileUtils.chmod('+x', OPTS[:output])
puts "✅: add exec permission to '#{OPTS[:output]}"


