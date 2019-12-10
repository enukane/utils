#!/usr/bin/env ruby
require 'resolv'

NAME=ARGV.shift
exit 1 if NAME.nil? or NAME.empty?

puts Resolv.getnames(NAME).join(", ")
