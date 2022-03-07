require "csv"
require "set"

BLUE = "#0f80ff"
PINK = "#fd66ff"
BLUE_FONT = '<font color=""#0f80ff"">'
PINK_FONT = '<font color=""#fd66ff"">'
END_FONT = "</font>"

REGEX_ONE = /<div class=""example-sentence"">([^div]*)<\/div>/
REGEX_TWO = /<div class=""example-sentence"">(.*?)<\/div>/

RELATIVE_PATH_TO_DECK = "./decks/Japanese_Cards.txt"

sentences_found = Set.new

opts = {
  quote_char: "¯" # Use a quote character that will definitly not appear in the file so that we don't blow up on normal double quotes
}

# Export cards as text file to get a deck that this can parse
CSV.foreach(RELATIVE_PATH_TO_DECK, **opts) do |row|
  row.each do |col|
    # skip to the next col unless this one has an example-sentence div
    next unless col.include?("example-sentence")
    # just match what's in the example-sentence div
    matches = col.match(REGEX_ONE)
    # skip to the next col if theres nothing good here
    next if matches.nil? || matches[1].nil? || matches[1].empty?
    # skip example sentences with blanks (either the japanese character or english one)
    next if matches[1].include?("＿") || matches[1].include?("_")

    # remove the font tags from the string
    plain_sentence = matches[1].delete(BLUE_FONT).delete(PINK_FONT).delete(END_FONT)

    # 1. check if there are parenthesis in the string
    sentence_split_on_parens = plain_sentence.split("(")
    if sentence_split_on_parens[-2]
      begin
        last_character_before_parens = sentence_split_on_parens[-2][-1]
        if ["。", "！", "？", "　", " ", ".", "!", "?"].include?(last_character_before_parens)
          # 2. remove contents in parenthesis at the end of the string if they are after punctuation
          plain_sentence = sentence_split_on_parens[0..-2].join("(")
        end
      rescue
        raise "PARENS REMOVAL DIDN'T WORK FOR: #{plain_sentence.inspect}"
      end
    end

    sentences_found << plain_sentence
  end
end

puts "=== #{sentences_found.size} sentences found! ==="
puts sentences_found.to_a
