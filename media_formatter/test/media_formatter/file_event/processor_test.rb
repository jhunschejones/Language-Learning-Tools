class FileEvent::ProcessorTest < Test::Unit::TestCase
  def setup
    # this setup runs before each test
    IO.any_instance.stubs(:puts)
  end

  def teardown
    # this teardown runs after each test
    IO.any_instance.unstub(:puts)
  end

  def test_processes_inbox_file_creation_events
    mock_processor = mock
    mock_processor.expects(:should_process_event?).once.returns(true)
    mock_processor.expects(:process_event).once
    Inbox::Processor.expects(:new).once.returns(mock_processor)
    FileEvent::Processor
      .new(interval: 0)
      .run
      .enqueue(FileEvent.new("test/fixture_files/inbox/goat_at_rest.jpeg", :created))
    sleep 0.2 # wait for queue to empty
  end

  def test_processes_inbox_file_found_events
    mock_processor = mock
    mock_processor.expects(:should_process_event?).once.returns(true)
    mock_processor.expects(:process_event).once
    Inbox::Processor.expects(:new).once.returns(mock_processor)
    FileEvent::Processor
      .new(interval: 0)
      .run
      .enqueue(FileEvent.new("test/fixture_files/inbox/goat_at_rest.jpeg", :found_in_inbox))
    sleep 0.2 # wait for queue to empty
  end

  def test_processes_audio_file_events
    mock_processor = mock
    mock_processor.expects(:should_process_event?).once.returns(true)
    mock_processor.expects(:process_event).once
    Audio::Processor.expects(:new).once.returns(mock_processor)
    FileEvent::Processor
      .new(interval: 0)
      .run
      .enqueue(FileEvent.new("test/fixture_files/18622.mp3", :created))
    sleep 0.2 # wait for queue to empty
  end

  def test_processes_image_events
    mock_processor = mock
    mock_processor.expects(:should_process_event?).once.returns(true)
    mock_processor.expects(:process_event).once
    Image::Processor.expects(:new).once.returns(mock_processor)
    FileEvent::Processor
      .new(interval: 0)
      .run
      .enqueue(FileEvent.new("test/fixture_files/goat_at_rest.jpeg", :created))
    sleep 0.2 # wait for queue to empty
  end

  def test_skips_unprocessable_events
    mock_processor = mock
    mock_processor.expects(:should_process_event?).once.returns(false)
    mock_processor.expects(:process_event).never
    Image::Processor.expects(:new).once.returns(mock_processor)
    FileEvent::Processor
      .new(interval: 0)
      .run
      .enqueue(FileEvent.new("test/fixture_files/goat_at_rest.jpeg", :deleted))
    sleep 0.2 # wait for queue to empty
  end

  def test_processes_a_list_of_enqueued_events
    number_of_events = 5
    mock_processor = mock
    mock_processor.expects(:should_process_event?).times(number_of_events).returns(true)
    mock_processor.expects(:process_event).times(number_of_events)
    Image::Processor.expects(:new).times(number_of_events).returns(mock_processor)

    file_event = FileEvent.new("test/fixture_files/goat_at_rest.jpeg", :created)
    events_to_process = []
    number_of_events.times { events_to_process << file_event }

    FileEvent::Processor
      .new(interval: 0)
      .run
      .enqueue(events_to_process)
    sleep 0.2 # wait for queue to empty
  end
end
