require "test/unit"
require "mocha/test_unit"
require "rake"
require "fileutils"
require_relative "../lib/module_loader"

# Make sure the DB is set up
`VERBOSE=false SCRIPT_ENV=test RAKE_ENV=test bundle exec rake db:create db:migrate`

Test::Unit.at_start do
  # this setup runs once at the start
end

Test::Unit.at_exit do
  # this setup runs once at the very end of the test
end
