require "logger"
require "tty-prompt"

Dir["#{File.dirname(__FILE__)}/*.rb"].each { |f| require(f) }
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require(f) }

$logger = Logger.new("tmp/log.txt")
