# Japanese To Audio

[![CI](https://github.com/jhunschejones/Ruby-Scripts/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/jhunschejones/Ruby-Scripts/actions/workflows/ci.yml)

### Overview
This script will convert a Japanese sentence or word into an MP3 audio file using Amazon Polly.

### Setup
1. Set environment variables for AWS: `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
2. Set `AUDIO_OUTPUT_FOLDER` to point to where you want the audio output files to go _(no trailing `/` in path)_
2. Run the interactive CLI with `./bin/run`
