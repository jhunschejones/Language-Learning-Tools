#!/usr/bin/env ruby

# SCRIPT:
# https://gist.github.com/kylophone/84ba07f6205895e65c9634a956bf6d54
# Addressing bug with short files:
# https://superuser.com/questions/1281327/ffmpeg-loudnorm-filter-does-not-make-audio-louder
# https://stackoverflow.com/questions/6239350/how-to-extract-duration-time-from-ffmpeg-output
#
if ARGF.argv.count != 2
  puts "Usage: #{$PROGRAM_NAME} input.mp3 output.mp3"
  exit 1
end

input_file_duration = `ffprobe -i #{ARGF.argv[0]} -show_entries format=duration -v quiet -of csv='p=0'`.chomp

if input_file_duration.to_f < 3.0
  `ffmpeg -y -hide_banner -loglevel panic -i #{ARGF.argv[0]} -af apad,atrim=0:3,loudnorm=I=-16:TP=-1.5,atrim=0:#{input_file_duration} -ar 44.1k #{ARGF.argv[1]}`
else
  `ffmpeg -y -hide_banner -loglevel panic -i #{ARGF.argv[0]} -af loudnorm=I=-16:TP=-1.5 -ar 44.1k #{ARGF.argv[0]}`
end
