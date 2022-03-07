class TestInbox
  include Inbox::Filename

  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end
end

class Inbox::FilenameTest < Test::Unit::TestCase
  def test_safe_audio_filename_reurns_expected_audio_filename
    expected_filename = "test/fixture_files/processed_audio/18622_test.mp3"
    assert_equal expected_filename, TestInbox.new("test/fixture_files/inbox/18622_test.mp3").send(:safe_audio_filename)
  end

  def test_safe_audio_filename_reurns_unique_filename_when_filename_already_exists
    # Put duplicate file in place
    FileUtils.cp("test/fixture_files/18622.mp3", "test/fixture_files/processed_audio/18622.mp3")
    safe_name_regex = /test\/fixture_files\/processed_audio\/18622_#{UUID::REGEX}.mp3/

    assert_match safe_name_regex, TestInbox.new("test/fixture_files/inbox/18622.mp3").send(:safe_audio_filename)

    # Cleanup
    File.delete("test/fixture_files/processed_audio/18622.mp3")
  end

  def test_safe_image_filename_reurns_expected_audio_filename
    expected_filename = "test/fixture_files/goat_at_rest_test.jpeg"
    assert_equal expected_filename, TestInbox.new("test/fixture_files/inbox/goat_at_rest_test.jpeg").send(:safe_image_filename)
  end

  def test_safe_image_filename_reurns_unique_filename_when_filename_already_exists
    safe_name_regex = /test\/fixture_files\/goat_at_rest_#{UUID::REGEX}.jpeg/
    assert_match safe_name_regex, TestInbox.new("test/fixture_files/inbox/goat_at_rest.jpeg").send(:safe_image_filename)
  end
end
