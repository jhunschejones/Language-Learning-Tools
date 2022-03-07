require "yaml"
require "csv"
require "logger"
require "fileutils"
require "rake"
require "active_record"
require "pcloud_api"
require_relative "../db/connection"

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless File.basename(file) == "main.rb"
end

LOCAL_DB_FILENAME = YAML.load(File.open("config/database.yml")).fetch(ENV["SCRIPT_ENV"])["database"]
PCLOUD_FOLDER_ID = ENV["PCLOUD_FOLDER_ID"].to_i

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["LOG_QUERIES"]
$logger = Logger.new("tmp/log.txt") unless ENV["SCRIPT_ENV"] == "test"
