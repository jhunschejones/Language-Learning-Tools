module Inbox
  module Filename
    protected

    def safe_audio_filename
      # Since processing audio files is currently an opt-in process rather than
      # the default, we'll drop inbox audio file in the audio deposite directory.
      if File.exist?("#{AUDIO_DEPOSIT_DIRECTORY}/#{basename}#{extension}")
        "#{AUDIO_DEPOSIT_DIRECTORY}/#{basename}_#{UUID.generate}#{extension}"
      else
        "#{AUDIO_DEPOSIT_DIRECTORY}/#{basename}#{extension}"
      end
    end

    def safe_image_filename
      if File.exist?("#{IMAGE_WATCH_DIRECTORY}/#{basename}#{extension}")
        "#{IMAGE_WATCH_DIRECTORY}/#{basename}_#{UUID.generate}#{extension}"
      else
        "#{IMAGE_WATCH_DIRECTORY}/#{basename}#{extension}"
      end
    end

    def basename
      File.basename(filename, extension)
    end

    def extension
      File.extname(filename)
    end

    def filename
      raise NotImplementedError
    end
  end
end
