require "bundler"
Bundler.require

# Authenticate a session with your Service Account
session = GoogleDrive::Session.from_service_account_key("client_secret.json")

# Get the spreadsheet by its title
spreadsheet = session.spreadsheet_by_title("Immersion Time Tracking")

# Find the worksheet and grab the data
_, _, total, per_days = spreadsheet
  .worksheets
  .select { |worksheet| worksheet.title == "Totals" }
  .first
  .rows
  .select { |row| row[0] == "All immersion" }
  .first

hours, minutes = total.split(":")
days_count = per_days.gsub("/ ", "").gsub(" days", "")

puts "#{hours}hrs #{minutes}mins of immersion in #{days_count} days"
