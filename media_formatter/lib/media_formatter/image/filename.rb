class Image
  module Filename
    RESIZED_SUFFIX = "_resized".freeze
    MINI_MAGICK_TEMP_SUFFIX = "~".freeze
    TEMP_FILE_EXTENSION = ".tinyifying".freeze
    TINYIFIED_IMAGE_SUFFIX = "_tinyified".freeze

    protected

    def temp_file_name
      "#{IMAGE_WATCH_DIRECTORY}/#{base_filename}#{TEMP_FILE_EXTENSION}"
    end

    def resized_file_name
      "#{IMAGE_WATCH_DIRECTORY}/#{base_filename}#{RESIZED_SUFFIX}#{file_extension}"
    end

    def safe_resized_file_name
      return resized_file_name unless File.exist?(resized_file_name)
      "#{IMAGE_WATCH_DIRECTORY}/#{base_filename}_#{UUID.generate}#{RESIZED_SUFFIX}#{file_extension}"
    end

    def tinyified_file_name
      "#{IMAGE_WATCH_DIRECTORY}/#{base_filename}#{TINYIFIED_IMAGE_SUFFIX}#{file_extension}"
    end

    def safe_tinyified_file_name
      return tinyified_file_name unless File.exist?(tinyified_file_name)
      "#{IMAGE_WATCH_DIRECTORY}/#{base_filename}_#{UUID.generate}#{TINYIFIED_IMAGE_SUFFIX}#{file_extension}"
    end

    def backup_file_name
      "#{BACKUP_IMAGE_FILES_PATH}/#{base_filename}#{file_extension}"
    end

    def safe_backup_file_name
      return backup_file_name unless File.exist?(backup_file_name)
      "#{BACKUP_IMAGE_FILES_PATH}/#{base_filename}_#{UUID.generate}#{file_extension}"
    end

    def base_filename
      File.basename(filename, File.extname(filename))
    end

    def file_extension
      File.extname(filename)
    end

    def filename
      raise NotImplementedError
    end
  end
end
