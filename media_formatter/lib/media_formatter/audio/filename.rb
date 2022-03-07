module Audio
  module Filename
    SPECIAL_CHARACTERS = /[:'"\/\\.$,?!]/

    protected

    def processed_file_name
      "#{AUDIO_DEPOSIT_DIRECTORY}/#{base_filename}#{processed_suffix}.mp3"
    end

    def safe_processed_file_name
      return processed_file_name unless File.exist?(processed_file_name)
      "#{AUDIO_DEPOSIT_DIRECTORY}/#{base_filename}_#{UUID.generate}#{processed_suffix}.mp3"
    end

    def backup_file_name
      "#{BACKUP_AUDIO_FILES_PATH}/#{base_filename}#{file_extension}"
    end

    def safe_backup_file_name
      return backup_file_name unless File.exist?(backup_file_name)
      "#{BACKUP_AUDIO_FILES_PATH}/#{base_filename}_#{UUID.generate}#{file_extension}"
    end

    def cli_safe_file_name
      "#{AUDIO_WATCH_DIRECTORY}/#{base_filename.gsub(SPECIAL_CHARACTERS, "").split.join("_").downcase}#{file_extension}"
    end

    def processed_suffix
      "_processed_#{::Audio::Processor::PEAK_LEVEL}#{::Audio::Processor::LOUDNESS}"
    end

    def base_filename
      File.basename(filename, file_extension)
    end

    def file_extension
      File.extname(filename)
    end

    def filename
      raise NotImplementedError
    end
  end
end
