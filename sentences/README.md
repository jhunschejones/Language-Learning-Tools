# Sentences

### Overview:
The sentences script is a simple CLI tool for storing and retrieving example sentences for Japanese language learning, along with their associated audio files. File storage uses pCloud as the cloud storage provider and metadata about the sentences is stored in a sqlite database.

### In use:
To use the script you will need to set up a pCloud access token and folder id. This can be done following the documentation for the `pcloud_api` gem [here](https://github.com/jhunschejones/pcloud_api). You can then set these values under the environment variables `PCLOUD_API_ACCESS_TOKEN`, `PCLOUD_API_DATA_REGION` and `PCLOUD_FOLDER_ID` in your `/tmp/.env` file.

After setup, simply run:
1. `bundle install`
2. `./bin/run`
