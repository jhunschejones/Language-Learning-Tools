class TestAudioFile
  include Audio::Filename

  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end
end

class Audio::FilenameTest < Test::Unit::TestCase

  def setup
    # this setup runs before each test
    @filename = "test/fixture_files/18622.mp3"
  end

  def teardown
    # this teardown runs after each test
  end

  def test_safe_processed_file_name_returns_normal_filename
    normal_processed_file_name = TestAudioFile.new(@filename).send(:processed_file_name)
    assert_equal normal_processed_file_name, TestAudioFile.new(@filename).send(:safe_processed_file_name)
  end

  def test_safe_processed_file_name_returns_unique_filename_when_filename_already_exists
    processed_file_name = TestAudioFile.new(@filename).send(:processed_file_name)
    processed_suffix = TestAudioFile.new(@filename).send(:processed_suffix)
    FileUtils.cp(@filename, processed_file_name)
    safe_name_regex = /test\/fixture_files\/processed_audio\/18622_#{UUID::REGEX}#{processed_suffix}.mp3/

    assert_match safe_name_regex, TestAudioFile.new(@filename).send(:safe_processed_file_name)

    File.delete(processed_file_name) # cleanup
  end

  def test_safe_backup_file_name_returns_normal_filename
    normal_backup_file_name = TestAudioFile.new(@filename).send(:backup_file_name)
    assert_equal normal_backup_file_name, TestAudioFile.new(@filename).send(:safe_backup_file_name)
  end

  def test_safe_backup_file_name_returns_unique_filename_when_filename_already_exists
    backup_file_name = TestAudioFile.new(@filename).send(:backup_file_name)
    FileUtils.cp(@filename, backup_file_name)
    safe_name_regex = /test\/fixture_files\/backups\/18622_#{UUID::REGEX}.mp3/

    assert_match safe_name_regex, TestAudioFile.new(@filename).send(:safe_backup_file_name)

    File.delete(backup_file_name) # cleanup
  end

  def test_cli_safe_file_name_removes_special_characters_and_spaces
    unsafe_file_name = "test/fixture_files/This\ Na?me\ $$\ Has\ Character.mp3"
    safe_file_name = "test/fixture_files/this_name_has_character.mp3"
    FileUtils.cp(@filename, unsafe_file_name)

    assert_match safe_file_name, TestAudioFile.new(unsafe_file_name).send(:cli_safe_file_name)

    File.delete(unsafe_file_name) # cleanup
  end
end
