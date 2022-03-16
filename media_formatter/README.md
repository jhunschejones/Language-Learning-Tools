# Media Formatter

[![CI](https://github.com/jhunschejones/Language-Learning-Tools/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/jhunschejones/Language-Learning-Tools/actions/workflows/ci.yml)

### Overview
Media Formatter is a script that I run in the console while creating flashcards for learning Japanese. As a part of my card creation process, I download pneumonic images for each new word I'm learning. Previously, I was re-sizing and optimizing the files by hand after downloading them. This required a lot of clicks per flashcard and subtly burned down my energy in the background with hundreds of small, repetitive decisions over a single card-creation session.

Media Formatter helps with this process by watching the directory where I download images for my flashcards. When a new image arrives, it checks if it is a supported file format, and if the image height and file size match my target settings. If not, it uses the [Tinyify API](https://tinypng.com/developers) to optimize and re-size the image for me and moves the original image into a backup directory so it's out of the way. This changes my image download and optimization process from the slowest to one of the fastest steps in the card creation workflow, and saves my mental energy for the steps I actually care about _(like coming up with memorable pneumonics!)_

### In Use

#### Working with images
1. Make sure the `IMAGE_WATCH_DIRECTORY` and `BACKUP_IMAGE_FILES_PATH` constants are pointed at existing paths _(the script will create them in the OSX downloads directory if they do not exist.)_
2. `bundle install`
3. Install the required image processing utilities with `brew install imagemagick svgo jonof/kenutils/pngout`
4. For the script timeout functionality, install with `brew install coreutils`

Once this setup is complete, simply start the script with `./bin/run`, download images to the `IMAGE_WATCH_DIRECTORY` and observe Media Formatter doing it's work! To run the script without actually making calls to the Tinyify API, use `DRY_RUN=true ./bin/run`. NOTE: The `./bin/run` command includes an auto-timeout that closes the script after 90 minutes since I always forget to stop it after I'm done.

#### Working with audio
I am currently working on a second portion of this script which processes audio clips. To use this part of the app you will need to `brew install ffmpeg` if you haven't already. With some versions of xcode cli tools, you may also find that you need to disable Library Validation for ffmpeg to work properly.

Since audio "loudness" is a fairly complex attribute affected by many factors, it is hard to automate _(unlike image size or file size.)_ You can tweak settings in `lib/media_formatter/audio_processor.rb` like `PEAK_LEVEL` and `LOUDNESS`, but YMMV Drop audio files in the `AUDIO_WATCH_DIRECTORY` to see what the script can do with them. There are also a couple lose scripts in the repo at the moment from some previous research _(`loudness.rb` and `loudness_2.rb`)_ which show additional examples of how to work with the ffmpeg library from Ruby.
