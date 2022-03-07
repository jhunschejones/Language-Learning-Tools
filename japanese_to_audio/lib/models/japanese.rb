class Japanese
  INVALID_JAPANESE = /[^ー-龯ぁ-んァ-ン０-９Ａ-ｚ。、！？ー]/

  def initialize(string)
    @string = string
  end

  def is_valid?(allow_all_characters: false)
    return false if @string.nil? || @string.empty?
    return false if !allow_all_characters && @string.match?(INVALID_JAPANESE)
    true
  end

  def to_s
    @string
  end
end
