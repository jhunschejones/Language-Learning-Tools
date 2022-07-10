module Inbox
  class Processor
    include Inbox::Filename

    SUPPORTED_INBOX_EVENTS = [:found_in_inbox, :created].freeze

    attr_reader :filename, :event

    def initialize(filename, event)
      @filename = filename
      @event = event
    end

    def should_process_event?
      File.dirname(filename) == INBOX_DIRECTORY &&
        SUPPORTED_INBOX_EVENTS.include?(event)
    end

    def process_event
      if Image::Processor::SUPPORTED_EXTENSIONS.include?(extension)
        puts "Sorting image file from inbox: #{filename}".blue
        return FileUtils.mv(filename, safe_image_filename)
      end

      if Audio::Processor::SUPPORTED_EXTENSIONS.include?(extension)
        puts "Sorting audio file from inbox: #{filename}".blue
        return FileUtils.mv(filename, safe_audio_filename)
      end

      puts "Unrecognized inbox file #{filename}".red
    end
  end
end
