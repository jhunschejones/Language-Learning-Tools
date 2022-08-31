# MPV Defaults

### Overview:
[mpv](https://mpv.io/manual/stable/) is an incredibly powerful media player but requires some configuration to get it set up for active immersion. My intention with this repo is to capture my setup steps so that it's easier to do this all again from scratch.

### To set up:
1. `brew install mpv ffmpeg ffprobe`
2. `pip3 install ffsubsync` _(requires Python 3, `brew install python`)_
   * https://github.com/smacke/ffsubsync
3. Download [`mpvatious`](https://github.com/Ajatt-Tools/mpvacious)
4. Download [`autosubsync-mpv`](https://github.com/Ajatt-Tools/autosubsync-mpv)
5. Run the script `./bin/run` and follow the instructions in the CLI
6. Install the [clipboard inserter](https://chrome.google.com/webstore/detail/clipboard-inserter/deahejllghicakhplliloeheabddjajm?hl=en) Chrome extension and allow access to file URLs in settings
7. Optional: Use the yomichan search page with clipboard observation enabled instead of https://texthooker.com/ if you prefer

### Using mpv:
* `mpv <drag video here>` to play a video
* `command + 0` for smaller window view
* `v` to hide / show subtitles
* `a` to bring up `mpvatious` menu, then `t` to enable clipboard auto-copy (for use with clipboard inserter and https://texthooker.com/)
* `q` to quit
* `shift + s` screenshot without subtitles
* `n` to open the menu to sync subtitles to audio
* `#` cycle through audio tracks

Seeking:
* `Shift+h` and `Shift+l` - Seek to the previous or the next subtitle.
* `Alt+h` and `Alt+l` - Seek to the previous, or the next subtitle, and pause.
* `Ctrl+h` - Seek to the start of the currently visible subtitle.
* `Ctrl+Shift+h` - Replay current subtitle line, and pause.
* `Ctrl+Shift+l` - Play until the end of the next subtitle, and pause.
