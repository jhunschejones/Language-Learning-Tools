require "test/unit"
require "mocha/test_unit"
require "tempfile"
require_relative "../lib/module_loader"

Test::Unit.at_start do
  # this setup runs once at the start
end

Test::Unit.at_exit do
  # this setup runs once at the very end of the test
end
