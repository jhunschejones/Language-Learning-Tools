require_relative "../test_helper"

class JapaneseTest < Test::Unit::TestCase

  def test_is_valid_returns_false_when_invalid
    refute Japanese.new(nil).is_valid?
    refute Japanese.new("").is_valid?
    refute Japanese.new("It's Friday!").is_valid?
    refute Japanese.new("金曜日です！ It's Friday!").is_valid?
  end

  def test_is_valid_returns_true_when_valid
    assert Japanese.new("今").is_valid?
    assert Japanese.new("あ！明日は金曜日ですか？").is_valid?
  end

  def test_is_valid_returns_true_when_allow_all_characters_and_valid_characters
    assert Japanese.new("It's Friday!").is_valid?(allow_all_characters: true)
  end

  def test_is_valid_returns_false_when_allow_all_characters_nil_or_blank
    refute Japanese.new(nil).is_valid?(allow_all_characters: true)
    refute Japanese.new("").is_valid?(allow_all_characters: true)
  end

  def test_to_s_returns_the_origional_string
    assert_equal "あ！明日は金曜日ですか？", Japanese.new("あ！明日は金曜日ですか？").to_s
  end
end
