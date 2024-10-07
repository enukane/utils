#!/usr/bin/ruby

arg = ARGV.shift
is_freqon = false
if arg == "f"
  is_freqon = true
  arg = ARGV.shift
end


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

FREQMAP = {
  1 => "2100 MHz (1920-1980/2110-2170)",
  3 => "1800 MHz (1710-1785/1805-1880)",
  8 => "900 MHz (880-915/925-960)",
  11 => "1500 MHz (1427-1447/1475-1495)",
  18 => "850 MHz (815-830/860-875)",
  19 => "850 MHz (830-845/875-890)",
  21 => "1500 MHz (1447-1462/1495-1510)",
  26 => "850 MHz (814–849/859–894)",
  28 => "700 MHz (703–748/758–803)",
  41 => "2500 MHz (2496–2690)",
  42 => "3500 MHz (3400–3600)",
  "n77" => "3700 MHz (3300–4200)",
  "n78" => "3500 MHz (3300–3800)",
  "n79" => "4700 MHz (4400–5000)",
  "n257" => "28 GHz (26.5-29.5)",

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

def list_band_from(bands, freqon)
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




