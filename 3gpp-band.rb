#!/usr/bin/ruby

arg = ARGV.shift

DOCOMO_BAND = {
  1 =>  :LTE,
  3 =>  :LTE,
  19 => :LTE,
  21 => :LTE,
  28 =>  :LTE,
  42 => :LTE,
  "n78" => :NR,
  "n79" => :NR,
  "n257" => :NR,
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
  "n77" => :NR,
  "n78" => :NR,
  "n257" => :NR,
}

SOFTBANK_BAND = {
  1 =>  :LTE,
  3 =>  :LTE,
  8 => :LTE,
  11 => :LTE,
  28 =>  :LTE,
  41 => :LTE,
  42 => :LTE,
  "n77" => :NR,
  "n257" => :NR,
}

RAKUTEN_BAND = {
  3 => :LTE,
  18 => :LTE,
  "n77" => :NR,
  "n257" => :NR,
}

LOCAL5G_BAND = {
  "n79" => :NR,
  "n257" => :NR,
}

def keys_include?(hash, key)
  return hash.keys.include?(key)
end

def check_mno_band(band)
  ary = []
  if keys_include?(DOCOMO_BAND, band)
     ary << "docomo"
  end
  if keys_include?(AU_BAND, band)
    ary << "au"
  end
  if keys_include?(SOFTBANK_BAND, band)
    ary << "softbank"
  end
  if keys_include?(RAKUTEN_BAND, band)
    ary << "rakuten"
  end
  if keys_include?(LOCAL5G_BAND, band)
    ary << "local5g"
  end
  return ary
end

case arg
when nil
  puts "DOCOMO:   " + DOCOMO_BAND.keys.join(", ")
  puts "AU:       " + AU_BAND.keys.join(", ")
  puts "SOFTBANK: " + SOFTBANK_BAND.keys.join(", ")
  puts "RAKUTEN:  " + RAKUTEN_BAND.keys.join(", ")
  puts "LOCAL5G:  " + LOCAL5G_BAND.keys.join(", ")
when /^[dD]ocomo/
  puts "DOCOMO:   " + DOCOMO_BAND.keys.join(", ")
when /^[aA][uU]$/
  puts "AU:       " + AU_BAND.keys.join(", ")
when /^[Ss]oftbank$/
  puts "SOFTBANK: " + SOFTBANK_BAND.keys.join(", ")
when /^[Rr]akuten$/
  puts "RAKUTEN:  " + RAKUTEN_BAND.keys.join(", ")
when /^[Ll]ocal5[Gg]$/
  puts "LOCAL5G:  " + LOCAL5G_BAND.keys.join(",")
when /^n[0-9]+$/
  band = arg.to_s
  puts check_mno_band(band).join(", ")
when /^[0-9]+$/
  band = arg.to_i
  puts check_mno_band(band).join(", ")
else
  puts "usage: 3gpp-band.rb <carrier|bandnumber|nXX>"
  puts "    carrier := docomo | au | softbank | rakuten | local5g"
end




