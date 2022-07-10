class Image
  class Processor
    include Image::Filename

    TARGET_HEIGHT_PX = 480
    TARGET_FILESIZE_KB = 50
    SUPPORTED_EXTENSIONS = [".jpeg", ".jpg", ".png", ".webp"].freeze

    attr_reader :event, :image

    def initialize(filename_from_event, event_name)
      @event = event_name
      @image = Image.new(filename_from_event)
    end

    def process_event
      if image.height > TARGET_HEIGHT_PX
        log("====== Resizing #{filename} ======".yellow)
        backup_origional_image
        resize_image
        return true
      end

      if image.filesize_kb > TARGET_FILESIZE_KB
        begin
          log("====== Tinyifying #{filename} ======".green)
          create_temp_file
          tinyify_image
          backup_origional_image
          clean_up_temp_file
          return true
        rescue => e
          log("Unable to tinyify #{filename}: #{e.message}".red)
        end
      end

      puts "Skipping #{event} event for #{filename}: filesize is already small enough"
    end

    def should_process_event?
      event == :created &&
        !filename.include?(TINYIFIED_IMAGE_SUFFIX) &&
        !filename.include?(TEMP_FILE_EXTENSION) &&
        filename[-1] != MINI_MAGICK_TEMP_SUFFIX &&
        SUPPORTED_EXTENSIONS.include?(file_extension)
    end

    private

    def filename
      @image.filename
    end

    def resize_image
      # This image magic gemoetry syntax instructs the library to resize the image
      # if the height is greater than our max height, then save it to the same
      # file name.
      image.mini_magick.geometry("x#{TARGET_HEIGHT_PX}>").write(safe_resized_file_name)
    end

    def tinyify_image
      processed_file_name = safe_tinyified_file_name
      if ENV["USE_TINYPNG"]
        Tinify.from_file(filename).to_file(processed_file_name)
      else
        FileUtils.mv(ImageOptim.new.optimize_image(image.filename), processed_file_name)
      end
      processed_file_name
    end

    def create_temp_file
      File.new(temp_file_name, "w")
    end

    def clean_up_temp_file
      FileUtils.rm(temp_file_name)
    end

    def backup_origional_image
      if image_already_resized?
        # If the image has already been resized it is not an origional which
        # means we do not need to worry about backing it up.
        File.delete(filename)
      else
        File.rename(filename, safe_backup_file_name)
      end
    end

    def image_already_resized?
      filename.include?(RESIZED_SUFFIX)
    end
  end
end
