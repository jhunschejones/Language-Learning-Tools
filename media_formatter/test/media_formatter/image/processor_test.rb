class Image::ProcessorTest < Test::Unit::TestCase
  def setup
    # this setup runs before each test
    IO.any_instance.stubs(:puts)

    @test_file = "test/fixture_files/goats_in_action_test.jpeg"
    @resized_test_file = "test/fixture_files/goats_in_action_test#{Image::Filename::RESIZED_SUFFIX}.jpeg"
    @backed_up_test_file = "test/fixture_files/backups/goats_in_action_test.jpeg"
    FileUtils.cp("test/fixture_files/goats_in_action.jpeg", @test_file)
  end

  def teardown
    # this teardown runs after each test
    IO.any_instance.unstub(:puts)

    File.delete(@test_file) if File.exist?(@test_file)
    File.delete(@resized_test_file) if File.exist?(@resized_test_file)
  end

  def test_process_event_backs_up_the_origional_image
    Image::Processor.new(@test_file, :created).process_event
    assert File.exist?(@backed_up_test_file)
  end

  def test_process_event_resizes_images_that_are_too_tall
    refute Image.new(@test_file).height == Image::Processor::TARGET_HEIGHT_PX
    Image::Processor.new(@test_file, :created).process_event
    assert File.exist?(@resized_test_file)
    assert Image.new(@resized_test_file).height == Image::Processor::TARGET_HEIGHT_PX
  end

  def test_process_event_tinyfies_images_that_are_too_large
    mock_tinify_builder = mock
    mock_tinify_builder.expects(:to_file).once
    Tinify.expects(:from_file).once.returns(mock_tinify_builder)

    Image::Processor.new(@test_file, :created).process_event
    Image::Processor.new(@resized_test_file, :created).process_event
  end

  def test_process_event_does_not_modify_images_that_are_already_the_right_size
    unprocessed_small_test_file = "test/fixture_files/goat_at_rest.jpeg"
    resized_small_test_file = "test/fixture_files/goat_at_rest#{Image::Filename::RESIZED_SUFFIX}.jpeg"
    tinified_small_test_file = "test/fixture_files/goat_at_rest#{Image::Filename::TINYIFIED_IMAGE_SUFFIX}.jpeg"
    backed_up_small_test_file = "test/fixture_files/backups/goat_at_rest.jpeg"

    Image::Processor.new(unprocessed_small_test_file, :created).process_event

    assert File.exist?(unprocessed_small_test_file)
    refute File.exist?(resized_small_test_file)
    refute File.exist?(tinified_small_test_file)
    refute File.exist?(backed_up_small_test_file)
  end
end
