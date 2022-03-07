require "eiwa"

limit = 10
counter = 0
Eiwa.parse_file("jmdict.xml", type: :jmdict_e) do |entry|
  puts entry.inspect

  counter += 1

  break if counter == limit
end
