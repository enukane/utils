#!/usr/bin/env ruby


prev = 0
while line = STDIN.gets
  cur = line.to_f
  diff = cur - prev
  puts diff
  prev = cur
  STDOUT.flush
end
