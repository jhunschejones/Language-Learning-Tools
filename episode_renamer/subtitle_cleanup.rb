directory =
  if ARGV[0]
    ARGV[0]
  else
    puts "Drag a directory here to clean up subtitle names:"
    print "> "
    $stdin.gets.chomp.strip.gsub("\\", "")
  end
raise "Invalid directory '#{directory}'" unless File.exist?(directory)

Dir.chdir(directory)

episode_files = Dir.glob("*.mkv")
raise "No episodes found" unless episode_files.any?
subtitle_files = Dir.glob(["*.srt", "*.ass"]).sort
raise "No subtitle files found" unless subtitle_files.any?
unless episode_files.size == subtitle_files.size
  raise "#{episode_files.size} video files and #{subtitle_files.size} subtitles found"
end

episode_files.each_with_index do |episode_file, index|
  subtitle_file = subtitle_files[index]
  episode_name = File.basename(episode_file, File.extname(episode_file))
  File.rename(subtitle_file, "#{episode_name}#{File.extname(subtitle_file)}")
end

puts "Cleaned up #{subtitle_files.size} subtitle #{subtitle_files.one? ? "file" : "files"}"
