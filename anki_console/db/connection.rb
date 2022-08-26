connection_details = YAML.load(File.open("config/database.yml")).fetch("development")
ActiveRecord::Base.establish_connection(connection_details)

# NOTE:
# DB currently throws "no such collation sequence: unicase (SQLite3::SQLException)" error
# when searching by a field using this custom colation. There is a way to define custom
# colation in sqlite3 but I'm not sure how to hook into it from here.
# https://github.com/tenderlove/sqlite3-ruby/commit/05c56b402feaaea9f1c9bb2838c6af0d772af220
# db.collation(name, comparator)
