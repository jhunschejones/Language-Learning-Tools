# Anki Console

### Overview
My goal with this script is to provide a Ruby console for interacting with an Anki sqlite database.

### In use

#### To generate a schema
1. Copy your `collection.anki2` file to the `./db/` directory
2. Run `bundle exec rake db:schema:dump`
3. Check `db/schema.rb` for the schema

NOTE: https://github.com/ankidroid/Anki-Android/wiki/Database-Structure is a good source of information for what the different fields in the schema mean, as their names may not be entirely obvious.

#### Using the console
1. Copy your `collection.anki2` file to the `./db/` directory
2. `bundle install`
3. `bundle exec rake db:migrate` to remove custom collation method
4. `./bin/console`
5. Run active record queries to your hearts content!


**Example Queries:**
```ruby
# Build an Anki query that returns notes where all cards are suspended
note_ids = Deck.find_by(name: "Japanese").notes.all_cards_suspended.pluck(:id)
# https://docs.ankiweb.net/searching.html#object-ids
puts "nid:#{note_ids.join(",")}"
```
