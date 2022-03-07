require "csv"

puts "Reading ./csv/exported.csv..."

words_transformed = 0
CSV.open("csv/ready_for_jpstudy_import.csv", "wb") do |csv|
  csv << [
    :english,
    :japanese,
    :source_name,
    :source_reference,
    :cards_created,
    :cards_created_on,
    :cards_added_to_list_on,
    :note
  ]

  CSV.foreach("csv/exported.csv", headers: true) do |row|
    csv << [
      row["English"], # english
      row["Expression"], # japanese
      "Satori Reader", # source name
      nil, # source reference
      false, # cards created
      nil, # cards created on
      Time.now.strftime("%m/%d/%Y"), # cards added to list on
      row["Context1"], # note
    ]
    words_transformed += 1
  end
end

puts "Transformed #{words_transformed} words in .csv/ready_for_jpstudy_import.csv"
