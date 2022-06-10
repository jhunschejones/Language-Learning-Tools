require_relative "./test_helper"

class RakeTest < Test::Unit::TestCase

  def setup
    # this setup runs before each test
    IO.any_instance.stubs(:puts)
    Kernel.send(:define_method, :print) { |*args| "" }
  end

  def teardown
    # this teardown runs after each test
    IO.any_instance.unstub(:puts)
    Pcloud::Folder.unstub(:find)
    $stdin.unstub(:gets)
  end

  def test_upload_to_s3_uploads_database_file
    client_stub = Aws::S3::Client.new(stub_responses: true)
    resource_stub = Aws::S3::Resource.new(client: client_stub)
    Aws::S3::Resource.expects(:new).once.returns(resource_stub)
    Rake::Task["db:upload_to_s3"].invoke
  end

  def test_download_from_s3_gets_user_permission_when_the_remote_db_file_is_old_then_downloads_database_file
    client_stub = Aws::S3::Client.new(stub_responses: true)
    mock_object = mock()
    mock_object.stubs(:last_modified).returns(Date.strptime("01/01/2022", "%m/%d/%Y"))
    client_stub.expects(:get_object).times(2).returns(mock_object)
    $stdin.expects(:gets).returns("y").once # asking for user confirmation!
    Aws::S3::Client.expects(:new).returns(client_stub)

    # Copy the DB file before it gets overwritten
    FileUtils.mv("./db/local-test.db", "./tmp/local-test.db")
    FileUtils.cp("./tmp/local-test.db", "./db/local-test.db")

    Rake::Task["db:download_from_s3"].invoke

    # Put the DB file back
    FileUtils.mv("./tmp/local-test.db", "./db/local-test.db")
  end

  def test_upload_to_pcloud_uploads_database_file
    Pcloud::File.stubs(:upload!).returns(true)
    empty_folder = mock()
    empty_folder.stubs(:contents).returns([])
    Pcloud::Folder.expects(:find).returns(empty_folder)
    Pcloud::File.expects(:upload).once
    Rake::Task["db:upload_to_pcloud"].invoke
  end

  def test_download_from_pcloud_gets_user_confirmation_when_local_state_is_newer_than_remote_state
    mock_folder = mock()
    mock_folder.stubs(:contents).returns([
      Pcloud::File.new(
        id: 100100,
        name: "local-test.db",
        path: "/local-test.db",
        content_type: "binary",
        category_id: 0,
        size: 1992312,
        parent_folder_id: 0,
        is_deleted: false,
        created_at: "Sat, 25 Sep 2021 04:44:32 +0000",
        modified_at: "Sat, 25 Sep 2021 04:44:32 +0000"
      )
    ])
    Pcloud::Folder
      .expects(:find)
      .with(KANJI_LIST_PCLOUD_FOLDER_ID)
      .returns(mock_folder)
    $stdin.expects(:gets).returns("y").once
    ::File.expects(:open).once
    Rake::Task["db:download_from_pcloud"].invoke
  end

  def test_report_totals_to_sns_posts_sns_message
    client_stub = Aws::S3::Client.new(stub_responses: true)
    resource_stub = Aws::SNS::Resource.new(client: client_stub)
    resource_stub.expects(:topic).returns(resource_stub)
    resource_stub.expects(:publish).once
    Aws::SNS::Resource.expects(:new).returns(resource_stub)

    Rake::Task["db:report_totals_to_sns"].invoke
  end

  def test_report_totals_to_email_sends_email
    if defined?(Pony)
      Pony
        .expects(:mail)
        .with(has_keys(:to, :from, :subject, :body, :via))
        .once
      Rake::Task["db:report_totals_to_email"].invoke
    else
      puts "Unable to load pony. If you're not sending emails locally, don't worry about this error!"
    end
  end
end
