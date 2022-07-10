require_relative "./module_loader"

IMAGE_WATCH_DIRECTORY = File.expand_path("~/Downloads/Japanese/Card\ Images").freeze
BACKUP_IMAGE_FILES_PATH = File.expand_path("~/Downloads/Japanese/Card\ Images/_Pre\ Tinyification\ Images").freeze

AUDIO_WATCH_DIRECTORY = File.expand_path("~/Downloads/Japanese/Card\ Audio/To\ Process").freeze
AUDIO_DEPOSIT_DIRECTORY = File.expand_path("~/Downloads/Japanese/Card\ Audio/").freeze
BACKUP_AUDIO_FILES_PATH = File.expand_path("~/Downloads/Japanese/Card\ Audio/To\ Process/_RAW").freeze

# == Locate or create required state on startup ==
puts "Media Formatter is starting up...".cyan
FileUtils.mkdir_p(BACKUP_IMAGE_FILES_PATH) unless Dir.exist?(BACKUP_IMAGE_FILES_PATH)
FileUtils.mkdir_p(BACKUP_AUDIO_FILES_PATH) unless Dir.exist?(BACKUP_AUDIO_FILES_PATH)

# == Set up Tinyfy on startup ==
if ENV["USE_TINYPNG"]
  Tinify.key = ENV["TINIFY_API_KEY"]
  Tinify.validate!
  log("#{Tinify.compression_count} image compressions this month")
end

loop do
  puts "What file would you like to process?"
  print "> "
  user_input = $stdin.gets.chomp.strip.gsub("\\", "")
  exit(0) if ["q", "quit", "exit"].include?(user_input.downcase)
  FileEvent::Processor.process(FileEvent.new(user_input, :cli))
end
