class FileEvent
  attr_reader :filename, :event

  def initialize(filename, event)
    @filename = filename
    @event = event
  end
end
