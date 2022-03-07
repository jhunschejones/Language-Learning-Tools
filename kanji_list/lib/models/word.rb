class Word
  class << self
    def all
      YAML.load(File.open(WORD_LIST_YAML_PATH))[WORD_LIST_KEY]
    end

    def find_by(kanji:)
      all.find { |word| word.include?(kanji.character) }
    end
  end
end
