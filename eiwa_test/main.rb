require "eiwa"
require "pry"

search = "おはようございます"
found_word = nil

# https://github.com/searls/eiwa#passing-a-block
Eiwa.parse_file("jmdict.xml", type: :jmdict_e) do |entry|

  if entry&.readings&.first&.text == search || entry&.spellings&.first&.text == search
    found_word = entry
    break
  end
end

# found_word
binding.pry
