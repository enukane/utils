#!/usr/bin/env ruby
require "net/ping"

TARGET= ARGV.shift || "8.8.8.8"
SOURCE= ARGV.shift
TIMEOUT=2

begin
  Process.euid = 0
rescue => e
  STDERR.puts "Failed to set euid to root (#{e})"
  exit 1
end

flag_term = false

Signal.trap("INT") do |signo|
  flag_term = true
end

icmp = Net::Ping::ICMP.new(TARGET, nil, TIMEOUT)
if SOURCE
  icmp.bind(SOURCE)
end

def get_airport
  io = IO.popen("airport -I")
  data = io.read()
  io.close
  hash = {}
  data.split("\n").each do |line|
    key, val = line.strip.split(": ").map{|elm| elm.strip}
    hash[key] = val
  end
  return hash
end

loop do
  break if flag_term
  now = Time.now
  now_str = now.strftime("%Y-%m-%d %H:%M:%S")
  print "#{now_str}\t"
  if SOURCE
    print "[#{TARGET}<-#{SOURCE}]\t"
  else
    print "[#{TARGET}]\t"
  end
  airinfo = get_airport
  airinfo_str = "\tRSSI #{airinfo["agrCtlRSSI"]} BSSID #{airinfo["BSSID"]}"

  begin
    if icmp.ping
      puts "OK\t#{sprintf("%.3f", icmp.duration * 1000)} ms #{airinfo_str}"
    else
      puts "NG #{airinfo_str}"
    end
  rescue Errno::EHOSTUNREACH
    puts "NG\tunreachable"
  rescue Errno::EHOSTDOWN
    puts "NG\thostdown"
  rescue => e
    puts "NG\t#{e}"
  end
  $stdout.flush
  sleep 1
end
