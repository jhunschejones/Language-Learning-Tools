connection_details = YAML.load(File.open("config/database.yml")).fetch("development")
ActiveRecord::Base.establish_connection(connection_details)
