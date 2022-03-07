# Unique Cards

Unique Cards is a script that uses text exports of Anki decks to find occurrences of a searched word or phrase. I use this tool as a part of my Japanese language learning workflow to help eliminate duplicate study material or locate previous example sentences that could be re-used in a new card. These issues can be resolved within a single user profile using Anki's built in search, but once a collection spans multiple profiles, a tool like this is required for cross-profile searches.

### In use

1. Populate the `/decks` directory with .txt exports of the Anki decks you want to search
2. `./bin/run` will give you an interactive CLI to search through the decks
3. `./bin/word_wall` will print out the first field of every card in every deck
