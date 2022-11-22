require "csv"

all_data = []
Dir["just_anki/*.csv"].each_with_index do |filename, index|
  CSV.foreach(filename).with_index do |(date, time), index|
    next if index == 0
    all_data << [Date.strptime(date, "%m/%d/%Y"), time]
  end
end

condensed_ordered_data = {}

all_data
  .uniq # remove true duplicates
  .sort # sort by date then time
  .each { |(date, time)| condensed_ordered_data[date] = time } # pick the highest time for each date

CSV.open("./all_anki.csv", "w") do |csv|
  csv << ["Date", "Time (mins)"]
  condensed_ordered_data
    .to_a
    .reverse # put newest dates first
    .each { |(date, time)| csv << [date.strftime("%m/%d/%Y"), time] }
end
