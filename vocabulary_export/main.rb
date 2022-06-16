require "fileutils"

# Make a local copy of `vocab.db`
if File.exists?("/Volumes/Kindle/system/vocabulary/vocab.db")
  FileUtils.cp("/Volumes/Kindle/system/vocabulary/vocab.db", "./vocab.db")
elsif File.exists?("./vocab.db")
  # fall back to a local version if the script was run before and the device is no longer plugged in
else
  puts "Could not find `vocab.db`. Are you sure your Kindle is plugged in?"
  exit 0
end

`open .` # open this directory
`open https://fluentcards.com/kindle` # open a website to parse file
