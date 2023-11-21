directory =
  if ARGV[0]
    ARGV[0]
  else
    puts "Drag a directory here to rename episodes:"
    print "> "
    $stdin.gets.chomp.strip.gsub("\\", "")
  end
raise "Invalid directory '#{directory}'" unless File.exist?(directory)

Dir.chdir(directory)

episode_files = Dir.glob("*.mkv") + Dir.glob("*.mp4")
raise "No episodes found" unless episode_files.any?

puts "What would you like to do to clean up '#{episode_files.first}':"
puts "1. Replace text"
puts "2. Remove text"
puts "3. Smart cleanup"
print "> "
user_choice = $stdin.gets.chomp.strip

if ["1", "replace", "replace text"].include?(user_choice.downcase)
  puts "What part of '#{episode_files.first}' would you like to replace?"
  print "> "
  to_replace = $stdin.gets.chomp

  puts "What should go in place of '#{to_replace}'?"
  print "> "
  replacement_text = $stdin.gets.chomp

  episode_files.each do |file|
    File.rename(file, file.gsub(to_replace, replacement_text))
  end

  puts "Replaced text in #{episode_files.size} #{episode_files.one? ? "file" : "files"}"
elsif ["2", "remove", "remove text"].include?(user_choice.downcase)
  puts "What part of '#{episode_files.first}' would you like to remove?"
  print "> "
  to_remove = $stdin.gets.chomp

  episode_files.each do |file|
    File.rename(file, file.gsub(to_remove, ""))
  end

  puts "Removed text in #{episode_files.size} #{episode_files.one? ? "file" : "files"}"
elsif ["3", "smart", "smart cleanup"].include?(user_choice.downcase)
  text_between_brackets = /(\s?\[[\w]*\])/
  episode_files.each do |file|
    File.rename(file, file.gsub(text_between_brackets, ""))
  end

  puts "Smart cleaned text in #{episode_files.size} #{episode_files.one? ? "file" : "files"}"
end
