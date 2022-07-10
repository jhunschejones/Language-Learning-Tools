require "yaml"
require "logger"
require "fileutils"
require "filewatcher"
require "tinify"
require "mini_magick"
require "image_optim"

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless File.basename(file) == "main.rb"
end

$logger = Logger.new("tmp/log.txt") unless ENV["SCRIPT_ENV"] == "test"

def log(message)
  # Remove console color sequences in log messages
  $logger.debug(message.inspect.gsub(/"\\e\[\d{2}m|\\e\[0m"/, "")) if $logger
  puts message
end
