class Audio::ProcessorTest < Test::Unit::TestCase
  def setup
    # this setup runs before each test
  end

  def teardown
    # this teardown runs after each test
  end

  def test_process_event_removes_unsafe_characters_from_file_names
    unsafe_file_name = "test/fixture_files/18622$ Barg D?anger! test.mp3"
    safe_file_name = "test/fixture_files/18622_barg_danger_test.mp3"
    FileUtils.cp("test/fixture_files/18622.mp3", unsafe_file_name)

    Audio::Processor.new(unsafe_file_name, :created).process_event
    assert File.exist?(safe_file_name)

    File.delete(safe_file_name) # cleanup
  end
end
