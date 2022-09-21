require "eiwa"
require "pry"

word_search = "おはようございます"
found_word = nil
# https://github.com/searls/eiwa#passing-a-block
Eiwa.parse_file("jmdict.xml", type: :jmdict_e) do |entry|
  if entry&.readings&.first&.text == word_search || entry&.spellings&.first&.text == word_search
    found_word = entry
    break
  end
end

kanji_search = "私"
found_kanji = nil
# https://github.com/searls/eiwa#passing-a-block
Eiwa.parse_file("kanjidic2.xml", type: :kanjidic2) do |entry|
  if entry&.text == kanji_search
    found_kanji = entry
    break
  end
end

# Look at `found_word` or `found_kanji`
binding.pry
