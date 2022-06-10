# Kanji List

## Overview
Kanji List is a script that I use with a local database when I create flashcards for studying Japanese. I built this tool as a way to quickly see the unique kanji in a new set of vocabulary while taking into account which kanji I've already made cards for.

## In Use
This script runs an interactive CLI which will allow you to add, skip, and remove kanjis from the database as well as viewing the next unique kanji based on the wordlist in `./config/word_list.yml`. To launch the CLI:
1. `brew install coreutils` _(if you're using the auto timeout feature*)_
2. `bundle install`
3. `bundle exec rake db:create db:migrate`
4.  `./bin/run`

*NOTE: The `./bin/run` command includes an auto-timeout that closes the script after 90 minutes _(since I often forget to stop it after I'm done.)_

Most of the screens in the CLI are searchable if you begin typing the name of a command for faster navigation.

### Cloud Storage
For longer term persistence or for working across two machines, the app can save and restore your local database in pCloud or AWS S3. To use this functionality you will need to export some environment variables:
* For pCloud, set `PCLOUD_API_DATA_REGION`, `PCLOUD_API_ACCESS_TOKEN`, `KANJI_LIST_PCLOUD_FOLDER_ID`, and `KANJI_LIST_PCLOUD_ARCHIVE_FOLDER_ID`. _See `pcloud_api` gem instructions [here](https://github.com/jhunschejones/pcloud_api) if you need help finding these values._
* For AWS S3, set `AWS_REGION`, `AWS_BUCKET`, `AWS_ACCESS_KEY_ID`, and `AWS_SECRET_ACCESS_KEY`.

### Import/Export
You can import and export kanji from the script using CSV files:
`./bin/import-csv`
`./bin/export-csv`

### Test Suite:
1. `bundle install`
2. `SCRIPT_ENV=test rake db:create db:migrate`
3. `bundle exec ./bin/test`
