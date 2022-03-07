require "test/unit"
require "mocha/test_unit"
require "vcr"
require_relative "../lib/module_loader"

VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :webmock
  ["AWS_REGION", "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"].each do |key|
    config.filter_sensitive_data("<#{key}>") { ENV[key] }
  end
end

Test::Unit.at_start do
  # this setup runs once at the start
end

Test::Unit.at_exit do
  # this setup runs once at the very end of the test
end
