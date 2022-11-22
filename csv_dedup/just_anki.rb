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
