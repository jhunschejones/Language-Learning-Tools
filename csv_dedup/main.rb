require "csv"
require "pry"

Dir["in/*.csv"].each do |filename|
  # csv_table = CSV.parse(File.read(filename), headers: true)
  all_data = []
  CSV.foreach(filename) { |row| all_data << row }
  checksum = all_data.map { |row| row[2].to_f }.inject(0, :+)
  CSV.open("out/#{File.basename(filename)}", "w") do |csv|
    all_data.uniq.each { |row| csv << row }
  end
  uniq_checksum = all_data.uniq.map { |row| row[2].to_f }.inject(0, :+)
  puts filename
  puts "Col 3 sum #{checksum.to_i} :: Row count #{all_data.size}"
  puts "Col 3 sum #{uniq_checksum.to_i} :: Row count #{all_data.uniq.size}"
end
