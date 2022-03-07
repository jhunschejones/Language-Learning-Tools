class UUIDTest < Test::Unit::TestCase
  def test_generates_a_uuid_lookin_string
    assert UUID.generate.is_a?(String)
    assert_match UUID::REGEX, UUID.generate
  end
end
