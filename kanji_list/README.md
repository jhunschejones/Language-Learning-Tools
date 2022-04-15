# Kanji List

## Overview
Kanji List is a script that I use with a local database when I create flashcards for studying Japanese. I built this tool as a way to quickly see the unique kanji in a new set of vocabulary while taking into account which kanji I've already made cards for.

## In Use
This script runs an interactive CLI which will allow you to add, skip, and remove kanjis from the database as well as viewing the next unique kanji based on the wordlist in `./config/word_list.yml`. To launch the CLI:
1. `brew install coreutils` _(if you're using the auto timeout feature*)_
2. `bundle install`
3. `bundle exec rake db:create db:migrate`
4.  `./bin/run`

Most of the screens in the CLI are searchable if you begin typing the name of a command for faster navigation.

The Rakefile includes a couple custom commands to dump the local database to a yaml file or to re-create the database from a yaml file. These can be used for easy backup and restore processes that are less dependent on the DB structure for the project.

For longer term storage, the app will store and restore state in pCloud. To use this functionality you will need to export `PCLOUD_API_DATA_REGION`, `PCLOUD_API_ACCESS_TOKEN`, `KANJI_LIST_PCLOUD_FOLDER_ID`, and `KANJI_LIST_PCLOUD_ARCHIVE_FOLDER_ID` environment variables for the `pcloud_api` client.

*NOTE: The `./bin/run` command includes an auto-timeout that closes the script after 90 minutes (since I often forget to stop it after I'm done.)

### Test Suite:
1. `bundle install`
2. `bundle exec ./bin/test`
