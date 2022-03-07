class Image
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def height
    mini_magick.height
  end

  def filesize_kb
    (mini_magick.size.to_f / 1000).to_i
  end

  def mini_magick
    @mini_magick ||= MiniMagick::Image.open(filename)
  end
end
