require "test/unit"
require "mocha/test_unit"
require "rake"
require "fileutils"
require_relative "../lib/module_loader"

# Make custom rake tasks availibile for the unit tests
load "lib/tasks/db.rake"
Rake::Task.define_task(:environment)

# Make sure the DB is set up
`VERBOSE=false SCRIPT_ENV=test RAKE_ENV=test bundle exec rake db:create db:migrate`

Test::Unit.at_start do
  # this setup runs once at the start
  File.write(KANJI_YAML_DUMP_PATH, "added_kanji: ['形']\nskipped_kanji: []")
  Kanji.load_from_yaml_dump
  File.write(WORD_LIST_YAML_PATH, "#{WORD_LIST_KEY}: ['取り', '百万']")
end

Test::Unit.at_exit do
  # this setup runs once at the very end of the test
  File.delete(WORD_LIST_YAML_PATH) if File.exist?(KANJI_YAML_DUMP_PATH)
  File.delete(KANJI_YAML_DUMP_PATH) if File.exist?(KANJI_YAML_DUMP_PATH)
end
