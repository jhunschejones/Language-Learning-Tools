class FileEvent
  class Processor
    DEFAULT_FILE_PROCESSING_INTERVAL_SECONDS = 0.25

    def initialize(interval: DEFAULT_FILE_PROCESSING_INTERVAL_SECONDS)
      @events_to_process = Queue.new
      @interval = interval
    end

    def enqueue(events_to_process)
      # handles a single event or an array of events
      Array(events_to_process).each do |event|
        @events_to_process << event
      end
    end

    def run
      Thread.new do
        loop do
          if @events_to_process.size > 0
            process(@events_to_process.shift)
          end
          sleep @interval
        end
      end
      self # returning self to make this method chain-able
    end

    private

    def process(event_to_process)
      inbox_processor = Inbox::Processor.new(event_to_process.filename, event_to_process.event)
      image_processor = Image::Processor.new(event_to_process.filename, event_to_process.event)
      audio_processor = Audio::Processor.new(event_to_process.filename, event_to_process.event)
      return inbox_processor.process_event if inbox_processor.should_process_event?
      return image_processor.process_event if image_processor.should_process_event?
      return audio_processor.process_event if audio_processor.should_process_event?
      puts "Skipping #{event_to_process.event} event for #{event_to_process.filename}".gray
    end
  end
end
