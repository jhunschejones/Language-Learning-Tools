class TestImage
  include Image::Filename

  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end
end

class Image::FilenameTest < Test::Unit::TestCase
  def setup
    # this setup runs before each test
    @filename = "test/fixture_files/goat_at_rest.jpeg"
    @resized_file_name = "test/fixture_files/goat_at_rest#{Image::Filename::RESIZED_SUFFIX}.jpeg"
    @tinyified_file_name = "test/fixture_files/goat_at_rest#{Image::Filename::TINYIFIED_IMAGE_SUFFIX}.jpeg"
    @backup_file_name = "test/fixture_files/backups/goat_at_rest.jpeg"
  end

  def teardown
    # this teardown runs after each test
  end

  def test_safe_resized_file_name_returns_normal_filename
    assert_equal @resized_file_name, TestImage.new(@filename).send(:safe_resized_file_name)
  end

  def test_safe_resized_file_name_returns_unique_filename_when_filename_already_exists
    FileUtils.cp(@filename, @resized_file_name)
    safe_name_regex = /test\/fixture_files\/goat_at_rest_#{UUID::REGEX}#{Image::Filename::RESIZED_SUFFIX}.jpeg/
    assert_match safe_name_regex, TestImage.new(@filename).send(:safe_resized_file_name)

    File.delete(@resized_file_name) # cleanup
  end

  def test_safe_safe_tinyified_file_name_returns_normal_filename
    assert_equal @tinyified_file_name, TestImage.new(@filename).send(:safe_tinyified_file_name)
  end

  def test_safe_safe_tinyified_file_name_returns_unique_filename_when_filename_already_exists
    FileUtils.cp(@filename, @tinyified_file_name)
    safe_name_regex = /test\/fixture_files\/goat_at_rest_#{UUID::REGEX}#{Image::Filename::TINYIFIED_IMAGE_SUFFIX}.jpeg/
    assert_match safe_name_regex, TestImage.new(@filename).send(:safe_tinyified_file_name)

    File.delete(@tinyified_file_name) # cleanup
  end

  def test_safe_safe_backup_file_name_returns_normal_filename
    assert_equal @backup_file_name, TestImage.new(@filename).send(:safe_backup_file_name)
  end

  def test_safe_safe_backup_file_name_returns_unique_filename_when_filename_already_exists
    FileUtils.cp(@filename, @backup_file_name)
    safe_name_regex = /test\/fixture_files\/backups\/goat_at_rest_#{UUID::REGEX}.jpeg/
    assert_match safe_name_regex, TestImage.new(@filename).send(:safe_backup_file_name)

    File.delete(@backup_file_name) # cleanup
  end
end
