require "yaml"
require "logger"
require "rake"
require "tty-prompt"
require "active_record"
require "aws-sdk-s3"
require "aws-sdk-sns"
require "pcloud_api"
begin
require "pony"
rescue LoadError
  puts "Unable to load pony. If you're not sending emails locally, don't worry about this error!"
end
require_relative "../db/connection"

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless File.basename(file) == "main.rb"
end

WORD_LIST_KEY = "new_words".freeze
LOCAL_DB_FILENAME = YAML.load(File.open("config/database.yml")).fetch(ENV["SCRIPT_ENV"])["database"]
KANJI_LIST_PCLOUD_FOLDER_ID = ENV["KANJI_LIST_PCLOUD_FOLDER_ID"].to_i
KANJI_LIST_PCLOUD_ARCHIVE_FOLDER_ID = ENV["KANJI_LIST_PCLOUD_ARCHIVE_FOLDER_ID"].to_i
PCLOUD_STATE_FILE_REGEX = /(^.+\.yml$)|(^.+\.db$)/

if ENV["SCRIPT_ENV"] == "development"
  WORD_LIST_YAML_PATH = "config/word_list.yml".freeze
  AWS_BUCKET = "kanji-list".freeze
elsif ENV["SCRIPT_ENV"] == "test"
  WORD_LIST_YAML_PATH = "config/test_word_list.yml".freeze
  AWS_BUCKET = "test-kanji-list" # Doesn't actually exist
else
  raise "Unrecognized environment '#{ENV["SCRIPT_ENV"]}'"
end

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["LOG_QUERIES"]
$logger = Logger.new("tmp/log.txt") unless ENV["SCRIPT_ENV"] == "test"

File.write(WORD_LIST_YAML_PATH, "#{WORD_LIST_KEY}: []") unless File.exist?(WORD_LIST_YAML_PATH)
