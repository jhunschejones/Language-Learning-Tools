connection_details = YAML.load(File.open("config/database.yml")).fetch(ENV["SCRIPT_ENV"])
ActiveRecord::Base.establish_connection(connection_details)
