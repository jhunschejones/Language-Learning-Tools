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

  def test_upload_to_s3_dumps_db_yaml_and_uploads_two_files
    client_stub = Aws::S3::Client.new(stub_responses: true)
    resource_stub = Aws::S3::Resource.new(client: client_stub)
    Aws::S3::Resource.expects(:new).times(2).returns(resource_stub)

    Rake::Task["db:dump_to_yaml"].expects(:invoke).once
    Rake::Task["db:upload_to_s3"].invoke
  end

  def test_download_from_s3_gets_user_permission_then_downloads_two_files
    client_stub = Aws::S3::Client.new(stub_responses: true)
    client_stub.expects(:get_object).times(2)
    $stdin.expects(:gets).returns("y").once # asking for user confirmation!
    Aws::S3::Client.expects(:new).returns(client_stub)

    # Move the DB file before it gets overwritten
    FileUtils.mv("./db/local-test.db", "./tmp/local-test.db")

    Rake::Task["db:download_from_s3"].invoke

    # Put the DB file back
    FileUtils.mv("./tmp/local-test.db", "./db/local-test.db")
  end

  def test_upload_to_pcloud_dumps_db_yaml_and_uploads_two_files
    Pcloud::File.stubs(:upload!).returns(true)
    empty_folder = mock()
    empty_folder.stubs(:contents).returns([])
    Pcloud::Folder.expects(:find).returns(empty_folder)
    Pcloud::File.expects(:upload).times(2)
    Rake::Task["db:dump_to_yaml"].expects(:invoke).once
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
      ),
      Pcloud::File.new(
        id: 100100,
        name: "test_kanji_list_dump.yml",
        path: "/test_kanji_list_dump.yml",
        content_type: "text",
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
    $stdin.expects(:gets).returns("y").twice
    ::File.expects(:open).twice
    Rake::Task["db:download_from_pcloud"].invoke
  end

  # === Something is weird about the download_from_pcloud tests here ><
  # def test_download_from_pcloud_pulls_down_remote_state_when_local_state_is_not_newer
  #   mock_folder = mock()
  #   mock_folder.stubs(:contents).returns([
  #     Pcloud::File.new(
  #       id: 100100,
  #       name: "local-test.db",
  #       path: "/local-test.db",
  #       content_type: "binary",
  #       category_id: 0,
  #       size: 1992312,
  #       parent_folder_id: 0,
  #       is_deleted: false,
  #       created_at: Time.now.to_s,
  #       modified_at: Time.now.to_s
  #     ),
  #     Pcloud::File.new(
  #       id: 100100,
  #       name: "test_kanji_list_dump.yml",
  #       path: "/test_kanji_list_dump.yml",
  #       content_type: "text",
  #       category_id: 0,
  #       size: 1992312,
  #       parent_folder_id: 0,
  #       is_deleted: false,
  #       created_at: Time.now.to_s,
  #       modified_at: Time.now.to_s
  #     )
  #   ])
  #   Pcloud::Folder
  #     .expects(:find)
  #     .with(KANJI_LIST_PCLOUD_FOLDER_ID)
  #     .returns(mock_folder)
  #   $stdin.expects(:gets).never
  #   ::File.stubs(:open).twice
  #   Rake::Task["db:download_from_pcloud"].invoke
  # end

  # === I don't have a good way to test this right now
  # def test_download_from_pcloud_pulls_down_remote_state_when_local_state_is_missing
  #   File.delete("./db/local-test.db")
  #   File.delete("./db/test_kanji_list_dump.yml")
  #   Rake::Task["db:download_from_pcloud"].invoke
  #   assert File.exist?("./db/local-test.db")
  #   assert File.exist?("./db/test_kanji_list_dump.yml")
  # end

  def test_report_totals_to_sns_posts_sns_message
    client_stub = Aws::S3::Client.new(stub_responses: true)
    resource_stub = Aws::SNS::Resource.new(client: client_stub)
    resource_stub.expects(:topic).returns(resource_stub)
    resource_stub.expects(:publish).once
    Aws::SNS::Resource.expects(:new).returns(resource_stub)

    Rake::Task["db:report_totals_to_sns"].invoke
  end

  def test_report_totals_to_email_sends_email
    Pony
      .expects(:mail)
      .with(has_keys(:to, :from, :subject, :body, :via))
      .once
    Rake::Task["db:report_totals_to_email"].invoke
  end
end
