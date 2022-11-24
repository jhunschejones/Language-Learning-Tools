require "csv"

anki_rows = []
CSV.foreach("combined/1669074018_combined.csv") do |row|
  if row.first == "Study flashcards"
    # Habit,Date,Value,Unit,Memo,Tag
    date = row[1]
    time = row[2]
    unit = row[3]
    raise "Unexpected units" if unit != "min"
    anki_rows << [Date.parse(date).strftime("%m/%d/%Y"), time]
  end
end

CSV.open("just_anki/habit_tracker.csv", "w") do |csv|
  csv << ["Date", "Time (mins)"]
  anki_rows.reverse.each { |row| csv << row }
end


anki_rows = []
CSV.foreach("Japanese Study Log - Study Log.csv") do |row|
  if row[1] == "Study flashcards"
    # Date,Task name,Minutes,Notes
    date = row[0]
    time = row[2]
    anki_rows << [Date.strptime(date, "%m/%d/%y").strftime("%m/%d/%Y"), time]
  end
end

CSV.open("just_anki/japanese_study_log.csv", "w") do |csv|
  csv << ["Date", "Time (mins)"]
  anki_rows.reverse.each { |row| csv << row }
end

# multitimer can have more than one entry per date so this also combines the entries
anki_rows = Hash.new(0)
CSV.foreach("multitimer.csv") do |row|
  if row.first == "Study Flashcards"
    # Name,Date,Seconds,Comment
    date = row[1][0..11] # "Nov 12, 2022 at 2:53:35 PM"
    time = row[2].to_f / 60 # This is in seconds in the CSV

    date_string = Date.strptime(date, "%b %d, %Y").strftime("%m/%d/%Y")
    anki_rows[date_string] += time
  end
end

CSV.open("just_anki/multitimer.csv", "w") do |csv|
  csv << ["Date", "Time (mins)"]
  anki_rows.to_a.reverse.each { |row| csv << row }
end
