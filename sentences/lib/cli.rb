class Cli
  def initialize
    puts "====== WELCOME TO SENTENCE STORAGE =====".cyan
  end

  def run
    loop do
      puts "What would you like to do?"
      puts "1. Add a new sentence"
      puts "2. Look up an existing sentence"
      print "> "

      case menu_option = user_input
      when "1"
        add_a_new_sentence
      when "2"
        lookup_a_sentence
      else
        puts "Unrecognized menu option '#{menu_option}'".red
      end
    end
  rescue Interrupt
    puts "\nBye!".cyan
    exit 0
  end

  private

  def user_input
    input = $stdin.gets.chomp
    if ["QUIT", "Q", "EXIT"].include?(input.upcase)
      puts "Bye!".cyan
      exit 0
    end
    input
  end

  def add_a_new_sentence
    puts "What Japanese word is the sentence for?"
    print "> "
    japanese_word = user_input

    puts "What is the Japanese sentence?"
    print "> "
    japanese_sentence = user_input

    puts "What is the English translation of the sentence?"
    print "> "
    english_sentence = user_input

    sentence = Sentence.new(
      japanese_word: japanese_word,
      japanese_sentence: japanese_sentence,
      english_sentence: english_sentence
    )
    sentence.validate

    if (sentence.errors.attribute_names - [:pcloud_file_id]).any?
      applicable_error_messages = sentence
        .errors
        .messages
        .except(:pcloud_file_id)
        .map { |k, v| "#{k.to_s.capitalize.gsub("_", " ")} #{v.join(",")}" }
      puts applicable_error_messages.join(", ").red
      puts ""
      return
    end

    puts "Drag and drop the audio file here:"
    print "> "
    audio_file_path = user_input.strip.gsub("\\", "")

    new_filename = "#{japanese_sentence}#{File.extname(audio_file_path)}"
    new_file_path = "./tmp/#{new_filename}"
    FileUtils.cp(audio_file_path, new_file_path)

    pcloud_file = Pcloud::File.upload(
      folder_id: PCLOUD_FOLDER_ID,
      file: File.open(new_file_path)
    )
    sentence.pcloud_file_id = pcloud_file.id
    sentence.pcloud_download_url = pcloud_file.download_url

    if sentence.save
      puts "Sentence added!\n".green
    else
      puts sentence.errors.full_messages.join(", ").red
    end

    FileUtils.rm(new_file_path)
  rescue Errno::ENOENT
    puts "Invalid audio file".red
  end

  def lookup_a_sentence
    puts "Search by Japanese word:"
    print "> "
    user_search = user_input
    matching_sentences = Sentence.where("japanese_word LIKE :search OR japanese_sentence LIKE :search", search: "%#{user_search}%")
    puts "\nFound #{matching_sentences.size.to_s.cyan} #{matching_sentences.size == 1 ? "sentence" : "sentences"} matching '#{user_search}':"
    matching_sentences.each do |sentence|
      puts "#{sentence.japanese_sentence.green} (#{sentence.english_sentence})"
      puts sentence.pcloud_download_url.gray
    end
    puts ""
  end
end
