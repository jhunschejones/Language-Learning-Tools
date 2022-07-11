
class AudioFile
  SPECIAL_CHARACTERS = /[:'"\/\\.$,?!]/

  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def duration
    @duration ||= `ffprobe -i '#{filename}' -show_entries format=duration -v quiet -of csv='p=0'`.chomp
  end

  # ffmpeg has trouble determining loudness for audio files < 3s in length.
  def is_too_short_for_ffmpeg?
    duration.to_f < 3.0
  end

  def safe_processed_file_name
    file_extension = File.extname(filename)
    base_filename = File.basename(filename, file_extension)
    "./processed/#{base_filename.gsub(SPECIAL_CHARACTERS, "")}_loud_enough_#{Time.now.to_i}.mp3"
  end
end

class Processor
  PEAK_LEVEL = -3
  LOUDNESS = -20

  def self.process(audio_file)
    if audio_file.is_too_short_for_ffmpeg?
      # ffmpeg has trouble determining loudness for audio files < 3s in length.
      # To work around this limitation, this command pads the file out to 3s,
      # processes it, then trims it back to the original file length.
      `ffmpeg -y -hide_banner -loglevel panic -i '#{audio_file.filename}' -af apad,atrim=0:3,loudnorm=I=#{LOUDNESS}:TP=#{PEAK_LEVEL},atrim=0:#{audio_file.duration} -ar 44.1k '#{audio_file.safe_processed_file_name}'`
    else
      `ffmpeg -y -hide_banner -loglevel panic -i '#{audio_file.filename}' -af loudnorm=I=#{LOUDNESS}:TP=#{PEAK_LEVEL} -ar 44.1k '#{audio_file.safe_processed_file_name}'`
    end
  end
end

loop do
  puts "Drag and drop the file to process:"
  print "> "
  user_input = $stdin.gets.chomp.strip.gsub("\\", "")
  exit(0) if ["q", "quit", "exit"].include?(user_input.downcase)

  if File.exist?(user_input)
    Processor.process(AudioFile.new(user_input))
  end
end
