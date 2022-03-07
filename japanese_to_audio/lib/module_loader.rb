require "aws-sdk-polly"

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless File.basename(file) == "main.rb"
end
