# Heavily borrowing from https://jer-k.github.io/add-active-record-rake-tasks-to-gem

# Add the ability to run db:create/migrate/drop etc
include ActiveRecord::Tasks

root = File.expand_path("../..", __FILE__)
DatabaseTasks.root = root
DatabaseTasks.db_dir = File.join(root, "db")
DatabaseTasks.migrations_paths = [File.join(root, "db/migrate")]
DatabaseTasks.database_configuration = YAML.load(ERB.new(IO.read(File.join(root, "config/database.yml"))).result)

class SeedLoader
  def initialize(seed_file)
    @seed_file = seed_file
  end

  def load_seed
    load @seed_file if File.exist?(@seed_file)
  end
end

DatabaseTasks.seed_loader = SeedLoader.new(File.join(root, "db/seeds.rb"))
DatabaseTasks.env = ENV["SCRIPT_ENV"] || "development"

ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
ActiveRecord::Base.establish_connection(DatabaseTasks.env.to_sym)

load "active_record/railties/databases.rake"
