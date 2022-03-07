#!/usr/bin/env ruby

# SCRIPT:
# https://gist.github.com/kylophone/84ba07f6205895e65c9634a956bf6d54
# Addressing bug with short files:
# https://superuser.com/questions/1281327/ffmpeg-loudnorm-filter-does-not-make-audio-louder
# https://stackoverflow.com/questions/6239350/how-to-extract-duration-time-from-ffmpeg-output
#
require "open3"
require "json"

ffmpeg_bin = "/usr/local/bin/ffmpeg"
target_il = -16.0
target_lra = 7.0
target_tp = -1.5
samplerate = "44.1k"

if ARGF.argv.count != 2
  puts "Usage: #{$PROGRAM_NAME} input.mp3 output.mp3"
  exit 1
end

_stdin, stdout, _stderr, _wait_thr = Open3.popen3("ffprobe -i #{ARGF.argv[0]} -show_entries format=duration -v quiet -of csv='p=0'")
input_file_duration = stdout.read.chomp

ff_string = "#{ffmpeg_bin} -hide_banner "
ff_string += "-i #{ARGF.argv[0]} "
ff_string += if input_file_duration.to_f < 3.0
  "-af apad,atrim=0:3,loudnorm="
else
  "-af loudnorm="
end
ff_string += "I=#{target_il}:"
ff_string += "LRA=#{target_lra}:"
ff_string += "tp=#{target_tp}:"
ff_string += "print_format=json "
ff_string += "-f null -"

_stdin, _stdout, stderr, wait_thr = Open3.popen3(ff_string)

if wait_thr.value.success?
  stats = JSON.parse(stderr.read.lines[-12, 12].join)
  loudnorm_string = if input_file_duration.to_f < 3.0
    "-af apad,atrim=0:3,loudnorm="
  else
    "-af loudnorm="
  end
  loudnorm_string += "print_format=summary:"
  loudnorm_string += "linear=true:"
  loudnorm_string += "I=#{target_il}:"
  loudnorm_string += "LRA=#{target_lra}:"
  loudnorm_string += "tp=#{target_tp}:"
  loudnorm_string += "measured_I=#{stats["input_i"]}:"
  loudnorm_string += "measured_LRA=#{stats["input_lra"]}:"
  loudnorm_string += "measured_tp=#{stats["input_tp"]}:"
  loudnorm_string += "measured_thresh=#{stats["input_thresh"]}:"
  loudnorm_string += "offset=#{stats["target_offset"]}"
else
  puts stderr.read
  exit 1
end

ff_string = "#{ffmpeg_bin} -y -hide_banner "
ff_string += "-i #{ARGF.argv[0]} "
ff_string += loudnorm_string.to_s
if input_file_duration.to_f < 3.0
  ff_string += ",atrim=0:#{input_file_duration}"
end
ff_string += " -ar #{samplerate} "
ff_string += ARGF.argv[1].to_s

_stdin, _stdout, stderr, wait_thr = Open3.popen3(ff_string)

if wait_thr.value.success?
  puts stderr.read.lines[-12, 12].join
  exit 0
else
  puts stderr.read
  exit 1
end
