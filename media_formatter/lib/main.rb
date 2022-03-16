require_relative "./module_loader"

INBOX_DIRECTORY = File.expand_path("~/Downloads/Japanese/Media\ Downloads").freeze
INBOX_WATCH_PATH = File.expand_path("#{INBOX_DIRECTORY}/*").freeze

IMAGE_WATCH_DIRECTORY = File.expand_path("~/Downloads/Japanese/Card\ Images").freeze
IMAGE_WATCH_PATH = "#{IMAGE_WATCH_DIRECTORY}/*".freeze
BACKUP_IMAGE_FILES_PATH = File.expand_path("~/Downloads/Japanese/Card\ Images/_Pre\ Tinyification\ Images").freeze

AUDIO_WATCH_DIRECTORY = File.expand_path("~/Downloads/Japanese/Card\ Audio/To\ Process").freeze
AUDIO_WATCH_PATH = "#{AUDIO_WATCH_DIRECTORY}/*".freeze
AUDIO_DEPOSIT_DIRECTORY = File.expand_path("~/Downloads/Japanese/Card\ Audio/").freeze
BACKUP_AUDIO_FILES_PATH = File.expand_path("~/Downloads/Japanese/Card\ Audio/To\ Process/_RAW").freeze

# == Locate or create required state on startup ==
puts "Media Formatter is starting up...".cyan
FileUtils.mkdir_p(INBOX_DIRECTORY) unless Dir.exist?(INBOX_DIRECTORY)
FileUtils.mkdir_p(BACKUP_IMAGE_FILES_PATH) unless Dir.exist?(BACKUP_IMAGE_FILES_PATH)
FileUtils.mkdir_p(BACKUP_AUDIO_FILES_PATH) unless Dir.exist?(BACKUP_AUDIO_FILES_PATH)

# == Configure main file watcher settings ==
filewatcher = Filewatcher.new(
  [IMAGE_WATCH_PATH, AUDIO_WATCH_PATH, INBOX_WATCH_PATH],
  exclude: [BACKUP_IMAGE_FILES_PATH, BACKUP_AUDIO_FILES_PATH],
  interval: 0
)

# == Setup and start a file processing queue ==
file_event_processor = FileEvent::Processor.new.run

# == Enqueue all existing inbox files ===
Dir.entries(INBOX_DIRECTORY).each do |file|
  next if file[0] == "."

  file_found_event = FileEvent.new(
    File.expand_path("#{INBOX_DIRECTORY}/#{file}"),
    :found_in_inbox
  )
  file_event_processor.enqueue(file_found_event)
end

# == Run the main file watcher loop ==
filewatcher.watch do |watcher_event|
  file_event_processor.enqueue(
    watcher_event
      .to_a
      # Sometimes the watcher sees a list of events, sometimes just one.
      # This makes sure we're always passing a flat array of all events.
      .flat_map { |watcher_event| FileEvent.new(*watcher_event) }
  )
end
