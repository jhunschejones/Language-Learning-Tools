namespace :db do
  desc "Dump the database to a yaml file"
  task :dump_to_yaml do
    puts "Dumping database to ./#{KANJI_YAML_DUMP_PATH}".yellow
    Kanji.dump_to_yaml
  end

  desc "Reset the database from a yaml file"
  task :load_from_yaml do
    puts "Loading database from ./#{KANJI_YAML_DUMP_PATH}".yellow
    Kanji.load_from_yaml_dump
  end

  desc "Upload the database file and YAML dump to S3"
  task :upload_to_s3 do
    db_file_name = YAML.load(File.open("config/database.yml")).fetch(ENV["SCRIPT_ENV"])["database"]

    puts "Uploading ./#{db_file_name} to S3".yellow
    Aws::S3::Resource.new
      .bucket(AWS_BUCKET)
      .object(db_file_name.split("/").last)
      .upload_file("./#{db_file_name}")

    Rake::Task["db:dump_to_yaml"].invoke
    puts "Uploading ./#{KANJI_YAML_DUMP_PATH} to S3".yellow
    Aws::S3::Resource.new
      .bucket(AWS_BUCKET)
      .object(KANJI_YAML_DUMP_PATH.split("/").last)
      .upload_file("./#{KANJI_YAML_DUMP_PATH}")
  end

  desc "Download the database file and YAML dump from S3"
  task :download_from_s3 do
    puts "WARNING: you are about to overwrite your local database with your".red
    puts "         DB state in S3. Are you sure you want to proceed? [Y/n]".red
    unless ["y", "yes"].include?($stdin.gets.chomp.downcase)
      puts "Skipping remote state download"
      exit 0
    end

    db_file_name = YAML.load(File.open("config/database.yml")).fetch(ENV["SCRIPT_ENV"])["database"]
    client = Aws::S3::Client.new

    puts "Downloading ./#{db_file_name} from S3".yellow
    File.open("./#{db_file_name}", "wb") do |file|
      client.get_object({ bucket: AWS_BUCKET, key: db_file_name.split("/").last }, target: file)
    end

    puts "Downloading ./#{KANJI_YAML_DUMP_PATH} from S3".yellow
    File.open("./#{KANJI_YAML_DUMP_PATH}", "wb") do |file|
      client.get_object({ bucket: AWS_BUCKET, key: KANJI_YAML_DUMP_PATH.split("/").last }, target: file)
    end
  end

  desc "Upload state files to pCloud"
  task :upload_to_pcloud do
    Rake::Task["db:dump_to_yaml"].invoke

    # === Archive old files already in pCloud
    # NOTE: This will overwrite existing archive files for each day such that
    #       there is only ever one pair of archive files stored per day.
    Pcloud::Folder.find(KANJI_LIST_PCLOUD_FOLDER_ID)
      .contents
      .filter { |item| item.is_a?(Pcloud::File) }
      .filter { |file| file.name.match?(PCLOUD_STATE_FILE_REGEX) }
      .each do |file|
        file.update(
          name: "#{file.created_at.strftime("%Y_%m_%d")}_#{file.name}",
          parent_folder_id: KANJI_LIST_PCLOUD_ARCHIVE_FOLDER_ID
        )
      end

    # === Upload new state files
    puts "Uploading #{KANJI_YAML_DUMP_PATH.split("/").last} to pCloud...".yellow
    Pcloud::File.upload(
      folder_id: KANJI_LIST_PCLOUD_FOLDER_ID,
      filename: KANJI_YAML_DUMP_PATH.split("/").last,
      file: File.open("./#{KANJI_YAML_DUMP_PATH}")
    )

    puts "Uploading #{LOCAL_DB_FILENAME} to pCloud...".yellow
    Pcloud::File.upload(
      folder_id: KANJI_LIST_PCLOUD_FOLDER_ID,
      filename: LOCAL_DB_FILENAME,
      file: File.open("./#{LOCAL_DB_FILENAME}")
    )
  end

  desc "Download state files from pCloud"
  task :download_from_pcloud do
    Pcloud::Folder.find(KANJI_LIST_PCLOUD_FOLDER_ID)
      .contents
      .filter { |item| item.is_a?(Pcloud::File) }
      .filter { |file| file.name.match?(PCLOUD_STATE_FILE_REGEX) }
      .each do |state_file|
        filename = "./db/#{state_file.name}"
        # prompt if local file is newer than cloud state file
        if ::File.exist?(filename) && ::File.ctime(filename) > state_file.created_at
          puts "Local #{filename} is newer than the version in pCloud. Are you sure you want to overwrite the local file with an older copy? [Y/N]".red
          print "> ".red
          unless ["yes", "y"].include?($stdin.gets.chomp.downcase)
            puts "Skipping download of #{filename}...".yellow
            next
          end
        end
        # Only proceed with file download after confirmation or if cloud file is
        # not older than local file.
        ::File.open(filename, "w") do |file|
          file.binmode
          puts "Downloading #{filename} from pCloud...".yellow
          HTTParty.get(state_file.download_url, stream_body: true) do |fragment|
            file.write(fragment)
          end
        end
      end
  end

  desc "Count completed kanji and send to SNS"
  task :report_totals_to_sns do
    kanji_count_message = "#{Kanji.added.count} kanjis have been added with #{Kanji.remaining_characters.size} left to add as of #{Time.now.strftime("%B %d, %Y, %I:%M%P")}"
    Aws::SNS::Resource
      .new(region: ENV["AWS_REGION"])
      .topic(ENV["AWS_SNS_ARN"])
      .publish({ message: kanji_count_message })
    puts "Kanji report sent to SNS".yellow
  end

  desc "Count completed kanji and send to email using postfix"
  task :report_totals_to_email do
    Pony.mail(
      to: ENV["EMAIL_RECIPIENT"],
      from: "Kanji List <#{ENV["EMAIL_SENDER"]}>",
      subject: "Kanji Report",
      body: "#{Kanji.added.count} kanjis have been added with #{Kanji.remaining_characters.size} left to add as of #{Time.now.strftime("%B %d, %Y, %I:%M%P")}",
      via: :sendmail
    )
    puts "Kanji report email enqueued".yellow
  end
end
