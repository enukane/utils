#!/usr/bin/ruby

arg = ARGV.shift

DOCOMO_BAND = {
  1 =>  :LTE,
  3 =>  :LTE,
  19 => :LTE,
  21 => :LTE,
  28 =>  :LTE,
  42 => :LTE,
}

AU_BAND = {
  1 =>  :LTE,
  3 =>  :LTE,
  11 => :LTE,
  18 => :LTE,
  26 =>  :LTE,
  28 => :LTE,
  41 => :LTE,
  42 => :LTE,
}

SOFTBANK_BAND = {
  1 =>  :LTE,
  3 =>  :LTE,
  8 => :LTE,
  11 => :LTE,
  28 =>  :LTE,
  41 => :LTE,
  42 => :LTE,
}

RAKUTEN_BAND = {
  3 => :LTE,
  18 => :LTE,
}

case arg
when nil
  puts "DOCOMO:   " + DOCOMO_BAND.keys.join(", ")
  puts "AU:       " + AU_BAND.keys.join(", ")
  puts "SOFTBANK: " + SOFTBANK_BAND.keys.join(", ")
  puts "RAKUTEN:  " + RAKUTEN_BAND.keys.join(", ")
when /^[dD]ocomo/
  puts "DOCOMO:   " + DOCOMO_BAND.keys.join(", ")
when /^[aA][uU]$/
  puts "AU:       " + AU_BAND.keys.join(", ")
when /^[Ss]oftbank$/
  puts "SOFTBANK: " + SOFTBANK_BAND.keys.join(", ")
when /^[Rr]akuten$/
  puts "RAKUTEN:  " + RAKUTEN_BAND.keys.join(", ")
when /^[0-9]+$/
  band = arg.to_i
  def keys_include?(hash, key)
    return hash.keys.include?(key)
  end

  if keys_include?(DOCOMO_BAND, band)
    puts "docomo"
  end
  if keys_include?(AU_BAND, band)
    puts "au"
  end
  if keys_include?(SOFTBANK_BAND, band)
    puts "softbank"
  end
  if keys_include?(RAKUTEN_BAND, band)
    puts "rakuten"
  end
else
  puts "usage: 3gpp-band.rb <carrier|bandnumber>"
  puts "    carrier := docomo | au | softbank | rakuten"
end




