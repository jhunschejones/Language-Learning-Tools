module Audio
  class Processor
    include Audio::Filename

    SUPPORTED_EXTENSIONS = [".mp3", ".m4a", ".wav"].freeze
    PEAK_LEVEL = -3
    LOUDNESS = -20

    attr_reader :filename, :event

    def initialize(filename_from_event, event_name)
      @filename = filename_from_event
      @event = event_name
    end

    def process_event
      # If the filename is not CLI safe, just rename the file on this pass.
      # The filewatcher will catch the safe-named file on the next pass and
      # we'll process it then.
      return File.rename(filename, cli_safe_file_name) unless filename == cli_safe_file_name
      raise "Unable to find audio file duration" if input_file_duration.empty?
      log("====== Processing #{filename} ======".magenta)

      if audio_is_too_short?
        # ffmpeg has trouble determining loudness for audio files < 3s in length.
        # To work around this limitation, this command pads the file out to 3s,
        # processes it, then trims it back to the original file length.
        `ffmpeg -y -hide_banner -loglevel panic -i '#{filename}' -af apad,atrim=0:3,loudnorm=I=#{LOUDNESS}:TP=#{PEAK_LEVEL},atrim=0:#{input_file_duration} -ar 44.1k '#{safe_processed_file_name}'`
      else
        `ffmpeg -y -hide_banner -loglevel panic -i '#{filename}' -af loudnorm=I=#{LOUDNESS}:TP=#{PEAK_LEVEL} -ar 44.1k '#{safe_processed_file_name}'`
      end
      backup_origional_file
    rescue => e
      log("Unable to process #{filename}: #{e.message}".red)
    end

    def should_process_event?
      event == :created &&
        !filename.include?(processed_suffix) &&
        SUPPORTED_EXTENSIONS.include?(file_extension)
    end

    private

    def input_file_duration
      @input_file_duration ||= `ffprobe -i '#{filename}' -show_entries format=duration -v quiet -of csv='p=0'`.chomp
    end

    def audio_is_too_short?
      input_file_duration.to_f < 3.0
    end

    def backup_origional_file
      File.rename(filename, safe_backup_file_name)
    end
  end
end
