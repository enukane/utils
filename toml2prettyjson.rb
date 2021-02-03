#!/usr/bin/env ruby
require "tomlrb"
require "json"

str = ""
while line = STDIN.gets
  str += line
end

tomled = Tomlrb.parse(str)

print JSON.pretty_generate(tomled)
