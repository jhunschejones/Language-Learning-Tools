require_relative "../test_helper"

class SynthesizerTest < Test::Unit::TestCase

  def setup
    @test_client = Aws::Polly::Client.new(stub_responses: {
      synthesize_speech: stub(audio_stream: Tempfile.new)
    })
  end

  def teardown
    # this teardown runs after each test
  end

  def test_convert_japanese_to_audio_raises_for_invalid_japanese
    assert_raise Synthesizer::InvalidJapanese do
      Synthesizer.new(
        japanese: Japanese.new("Some english"),
        client: @test_client
      ).convert_japanese_to_audio
    end

    assert_raise Synthesizer::InvalidJapanese do
      Synthesizer.new(japanese: "A string", client: @test_client).convert_japanese_to_audio
    end

    assert_raise Synthesizer::InvalidJapanese do
      Synthesizer.new(japanese: nil, client: @test_client).convert_japanese_to_audio
    end
  end

  def test_convert_japanese_to_audio_outputs_expected_mp3_file_with_english_filename
    Synthesizer.new(
      japanese: Japanese.new("おはいようございます"),
      filename: "test",
      client: @test_client
    ).convert_japanese_to_audio

    assert File.exist?("./test/test.mp3")

    File.delete("./test/test.mp3")
  end

  def test_convert_japanese_to_audio_outputs_expected_mp3_file_with_japanese_filename
    Synthesizer.new(
      japanese: Japanese.new("おはいようございます"),
      filename: "おはいようございます",
      client: @test_client
    ).convert_japanese_to_audio

    assert File.exist?("./test/おはいようございます.mp3")

    File.delete("./test/おはいようございます.mp3")
  end

  def test_convert_japanese_to_audio_outputs_expected_mp3_file_with_mixed_characters
    Synthesizer.new(
      japanese: Japanese.new("Netflixのアカウント登録をしました。"),
      filename: "I registerd for a netflix account",
      allow_all_characters: true,
      client: @test_client
    ).convert_japanese_to_audio

    assert File.exist?("./test/I registerd for a netflix account.mp3")

    File.delete("./test/I registerd for a netflix account.mp3")
  end

  def test_convert_japanese_to_audio_uses_timestamp_when_no_filename_is_provided
    test_time = Time.now
    test_time_ms = (test_time.to_f * 1000).to_i
    Time.stubs(:now).returns(test_time)

    Synthesizer.new(
      japanese: Japanese.new("おはいようございます"),
      client: @test_client
    ).convert_japanese_to_audio
    assert File.exist?("./test/#{test_time_ms}.mp3")

    File.delete("./test/#{test_time_ms}.mp3")
  end

  def test_convert_japanese_to_audio_does_not_double_up_file_extensions
    Synthesizer.new(
      japanese: Japanese.new("おはいようございます"),
      filename: "test.mp3", # user passes a filename _with_ an extension
      client: @test_client
    ).convert_japanese_to_audio

    refute File.exist?("./test/test.mp3.mp3")
    assert File.exist?("./test/test.mp3")

    File.delete("./test/test.mp3")
  end
end
