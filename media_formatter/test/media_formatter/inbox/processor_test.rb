class Inbox::ProcessorTest < Test::Unit::TestCase
  def setup
    # this setup runs before each test
    IO.any_instance.stubs(:puts)
    @test_image_file = "test/fixture_files/inbox/goats_in_action_test.jpeg"
    FileUtils.cp("test/fixture_files/goats_in_action.jpeg", @test_image_file)

    @test_audio_file = "test/fixture_files/inbox/18622_test.mp3"
    FileUtils.cp("test/fixture_files/18622.mp3", @test_audio_file)
  end

  def teardown
    # this teardown runs after each test
    IO.any_instance.unstub(:puts)
    File.delete(@test_image_file) if File.exist?(@test_image_file)
    File.delete(@test_audio_file) if File.exist?(@test_audio_file)
  end

  def test_process_event_moves_image_files_to_watch_directory
    Inbox::Processor.new(@test_image_file, :created).process_event
    assert File.exist?("test/fixture_files/goats_in_action_test.jpeg")
    # cleanup
    File.delete("test/fixture_files/goats_in_action_test.jpeg")
  end

  # Since processing audio files is currently an opt-in process rather than the
  # default, we'll drop inbox audio file in the audio deposite directory.
  def test_process_event_moves_audio_files_to_the_deposit_directory
    Inbox::Processor.new(@test_audio_file, :created).process_event
    assert File.exist?("test/fixture_files/processed_audio/18622_test.mp3")
    # cleanup
    File.delete("test/fixture_files/processed_audio/18622_test.mp3")
  end
end
