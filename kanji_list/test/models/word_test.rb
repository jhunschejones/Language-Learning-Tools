require_relative "../test_helper"

class WordTest < Test::Unit::TestCase

  def setup
    # this setup runs before each test
  end

  def teardown
    # this teardown runs after each test
  end

  def test_all_returns_all_words_in_list
    assert_equal ["取り", "百万"], Word.all
  end

  def test_find_by_returns_word_for_kanji
    assert_equal "百万", Word.find_by(kanji: Kanji.new(character: "万"))
  end

  def test_find_by_returns_nil_when_no_word_is_found
    assert_equal nil, Word.find_by(kanji: Kanji.new(character: "人"))
  end
end
