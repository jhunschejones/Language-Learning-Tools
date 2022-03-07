class CLI
  def initialize
    @prompt = TTY::Prompt.new(
      interrupt: :exit,
      active_color: :green,
      track_history: false
    )
  end

  def run
    loop do
      search_word = @prompt.ask("What word would you like to find?")
      exit 0 if ["quit", "q", "exit"].include?(search_word)

      find_word_locations(search_word).each do |location|
        puts location_for_cli(location, search_word)
      end
    end
  end

  private

  def find_word_locations(word)
    found_locations = []
    Dir.glob("./decks/**/*.txt").each do |file_name|
      File.readlines(file_name).each do |line|
        next if line.to_s.empty?
        if line.include?(word)
          found_locations << [file_name, line]
        end
      end
    end
    found_locations
  end

  def location_for_cli(location, search_word)
    "#{"File".underline}: #{location.first} #{"Line".underline}: #{location.last.gsub(search_word, search_word.cyan).split.join(", ")}"
  end
end
