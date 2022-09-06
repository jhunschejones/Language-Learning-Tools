class CLI
  MENU_OPTIONS = [
    SHOW_NEXT_CHARACTER_OPTION = "Next character from word list",
    ADD_TO_WORD_LIST_OPTION = "Add new words to word list",
    ADVANCED_OPTION = "More options",
    QUIT_OPTION = "Quit"
  ].freeze
  NEXT_KANJI_OPTIONS = ["Open URLs", "Add", "Skip", "Back"].freeze
  ADVANCED_OPTIONS = [
    TOTALS_OPTION = "Total kanji count",
    ADD_OPTION = "Add kanji (freeform)",
    SKIP_OPTION = "Skip kanji (freeform)",
    REMOVE_OPTION = "Remove kanji (freeform)",
    BACK_OPTION = "Back"
  ].freeze

  def initialize
    @prompt = TTY::Prompt.new(
      interrupt: proc do
        puts "\n#{total_kanji_added_message}"
        exit 0
      end,
      active_color: :green,
      track_history: false
    )
  end

  def run
    loop do
      case @prompt.select(
        "What would you like to do? #{new_characters_remaining_message}",
        menu_options,
        filter: true,
        cycle: true
      )
      when SHOW_NEXT_CHARACTER_OPTION
        next_new_character_menu
      when ADD_TO_WORD_LIST_OPTION
        add_new_words_to_word_list
      when ADVANCED_OPTION
        advanced_menu
      when QUIT_OPTION
        puts total_kanji_added_message
        exit 0
      end
    end
  end

  private

  def next_new_character_menu(open_urls: true)
    next_kanji = Kanji.next

    # copy the next character to the clipboard (without newline)
    system("echo #{next_kanji.character} | tr -d '\n' | pbcopy")

    case @prompt.select(
      "Next kanji: #{next_kanji.character.cyan}, from #{Word.find_by(kanji: next_kanji)}",
      open_urls ? NEXT_KANJI_OPTIONS : NEXT_KANJI_OPTIONS.dup - ["Open URLs"],
      filter: true,
      cycle: true
    )
    when "Open URLs"
      uri_safe_kanji = URI.encode_www_form_component(next_kanji.character)
      # system("open https://en.wiktionary.org/wiki/#{uri_safe_kanji}#Japanese")
      system("open https://www.japandict.com/kanji/#{uri_safe_kanji}")
      system("open https://app.kanjialive.com/#{uri_safe_kanji}")
      next_new_character_menu(open_urls: false)
    when "Add"
      next_kanji.add!
    when "Skip"
      next_kanji.skip!
    end
  end

  def advanced_menu
    case @prompt.select(
      "Advanced options:",
      ADVANCED_OPTIONS,
      filter: true,
      cycle: true
    )
    when TOTALS_OPTION
      puts total_kanji_added_message
    when ADD_OPTION
      kanji_to_add = Kanji.new(character: @prompt.ask("What kanji would you like to add?")&.strip)
      begin
        puts "Kanji added: #{kanji_to_add.add!.character}".green
      rescue ActiveRecord::RecordInvalid
        puts "#{kanji_to_add.character} #{kanji_to_add.errors.first.message}".red
      end
    when SKIP_OPTION
      kanji_to_skip = Kanji.new(character: @prompt.ask("What kanji would you like to skip?")&.strip)
      begin
        puts "Kanji skipped: #{kanji_to_skip.skip!.character}".green
      rescue ActiveRecord::RecordInvalid
        puts "#{kanji_to_skip.character} #{kanji_to_skip.errors.first.message}".red
      end
    when REMOVE_OPTION
      character_to_remove = @prompt.ask("What kanji would you like to remove?")&.strip
      kanji_to_remove = Kanji.find_by(character: character_to_remove)
      if kanji_to_remove
        puts "Removed kanji: #{kanji_to_remove.destroy!.character}".yellow
        $logger.debug("Removed: #{kanji_to_remove.inspect}") if $logger
      else
        puts "Unable to find kanji character: #{character_to_remove}".red
      end
    end
  end

  def menu_options
    Kanji.next ? MENU_OPTIONS : MENU_OPTIONS[1..-1]
  end

  def new_characters_remaining_message
    "(#{Kanji.remaining_characters.size} kanji remaining)".cyan
  end

  def total_kanji_added_message
    message = ""
    counts = [
      { label: "Total kanji added:", count: Kanji.added.count },
      { label: "Jouyou:", count: Kanji.added.jouyou.count },
      { label: "Non-Jouyou:", count: Kanji.added.non_jouyou.count },
    ]

    counts.map.with_index do |count, index|
      message << "#{count[:label].gray} #{count[:count].to_s.cyan}"
      message << " (".gray && next if index == 0
      message << ")".gray && next if index == counts.size - 1
      message << ", ".gray
    end
    message.strip
  end

  def add_new_words_to_word_list
    new_words = @prompt
      .multiline("Add words separated by newlines or commas")
      .flat_map { |word| word.split(",").map(&:strip) }

    old_words = YAML.load(File.open(WORD_LIST_YAML_PATH))[WORD_LIST_KEY]

    File.open(WORD_LIST_YAML_PATH, "w") do |file|
      file.write({ WORD_LIST_KEY => (old_words + new_words).uniq }.to_yaml)
    end
  end
end
