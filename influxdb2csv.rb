#!/usr/bin/env ruby
require "optparse"

OPTS={
  :pit_key => nil,
  :token_influx => nil,
  :url_influx => nil,
  :org_influx => nil,
  :bucket_influx => nil,
  :fields => [],
  :output => nil,
}
opt = OptionParser.new

opt.on("-p VAL", "--pit==VAL") {|v|
  # XXX: implement
  OPTS[:pit_key] = v
}
opt.on("-T VAL", "--token==VAL") {|v|
  OPTS[:token_influx] = v
}
opt.on("-U VAL", "--url==VAL") {|v|
  OPTS[:url_influx] = v
}
opt.on("-O VAL", "--org==VAL") {|v|
  OPTS[:org_influx] = v
}
opt.on("-b VAL", "--bucket==VAL") {|v|
  OPTS[:bucket_influx] = v
}
opt.on("-f VAL", "--fields==VAL") {|v|
  OPTS[:fields] << v
}
opt.on("-o VAL", "--output==VAL") {|v|
  OPTS[:output] = v
}

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


def main(opts)
  if opts[:pit_key].nil? and opts[:token_influx].nil?
    raise "no influxdb info provided"
  end

  if opts[:pit_key]
    opts[:token_influx] = Pit.get(opts[:pit_key]["token"])
    opts[:url_influx]   = Pit.get(opts[:pit_key]["url"])
    opts[:org_influx]   = Pit.get(opts[:pit_key]["org"])
  end


end

main(OPTS)

# XXX: implement logic here
p "OPTS = #{OPTS}"
raise "main: unimplemented"
