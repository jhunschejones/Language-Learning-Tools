class Cli
  DELETE_PREVIOUS_LINE = "\033[A\033[K\033[A".freeze
  DELETE_CURRENT_LINE = "\033[1K\033[A".freeze

  def initialize
    unless Dir.exist?(Synthesizer::AUDIO_OUTPUT_FOLDER)
      raise "Invalid output folder: #{Synthesizer::AUDIO_OUTPUT_FOLDER}"
    end
    puts "====== WELCOME TO THE JAPANESE TO AUDIO CONVERTER =====".cyan
  end

  def run
    loop do
      puts "Provide some Japanese to convert to audio:"
      print "> "
      japanese = Japanese.new(user_input)

      unless japanese.is_valid?
        puts "Some characters don't look lile Japanese. Allow all characters? [Y/N]"
        print "> "
        allow_all_characters = ["y", "yes"].include?(user_input)
        unless allow_all_characters && japanese.is_valid?(allow_all_characters: true)
          puts "Sorry, I couldn't recognize '#{japanese}'".red
          next
        end
      end

      puts "What would you like to name the output file?"
      print "> "
      filename = user_input

      synthesizer = Synthesizer.new(
        japanese: japanese,
        filename: filename,
        allow_all_characters: allow_all_characters || false,
        voice: :female
      )

      # escaping spaces in the file so that the output is copy-paste-able into
      # other terminal commands
      destination_file = synthesizer.convert_japanese_to_audio.gsub(/\s/, "\\ ")
      puts "Generated #{destination_file} 🎉".green

      puts "Retry with male voice?"
      print "> "
      if ["y", "yes"].include?(user_input)
        synthesizer = Synthesizer.new(
          japanese: japanese,
          filename: filename,
          allow_all_characters: allow_all_characters || false,
          voice: :male
        )
        # escaping spaces in the file so that the output is copy-paste-able into
        # other terminal commands
        destination_file = synthesizer.convert_japanese_to_audio.gsub(/\s/, "\\ ")
        puts "Generated #{destination_file} 🎉".green
      else
        puts DELETE_PREVIOUS_LINE
        puts DELETE_PREVIOUS_LINE
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
end
