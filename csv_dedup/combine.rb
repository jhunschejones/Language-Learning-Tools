require "csv"

CSVS_TO_COMBINE = [
  "out/20200902_20221121_Habit_all except anki.csv",
  "out/20200902_20221121_Habit_all.csv",
  "out/20200902_20221121_Habit_first.csv",
  "out/20200902_20221121_Habit_second.csv"
]

output_filename = "combined/#{Time.now.to_i}_combined.csv"
all_data = []
CSVS_TO_COMBINE.each do |filename|
  CSV.foreach(filename) { |row| all_data << row }
end
CSV.open(output_filename, "w") do |csv|
  all_data.uniq.each { |row| csv << row }
end

puts "#{output_filename} created with #{all_data.uniq.size} rows"
