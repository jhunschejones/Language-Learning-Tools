class Cli
  class << self
    def user_input
      input = Readline.readline("> ", false).chomp.strip.gsub("\\", "")
      if ["QUIT", "Q", "EXIT"].include?(input.upcase)
        puts "Bye!"
        exit 0
      end
      input
    end
  end
end
