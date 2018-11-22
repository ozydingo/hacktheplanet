require 'minitest/autorun'

require_relative '../lib/font.rb'

class FontTest < Minitest::Test
  DATA = {
    'a' => [[0, 0, 0], [0, 1, 1], [1, 0, 1], [1, 0, 1], [0, 1, 1]],
    'x' => [[0, 0, 0], [1, 0, 1], [0, 1, 0], [1, 0, 1], [1, 0, 1]],
  }.freeze

  def test_font_data
    font = Font.load('data/font/3x5', 'txf')
    assert font.get('a') == DATA['a']
    assert font.get('x') == DATA['x']
    assert font.get('a') != DATA['x']
  end

  def test_font_fails_on_bad_path
    assert_raises(Errno::ENOENT) do
      font = Font.load('data/font/foo', 'txf')
    end
  end

  def test_font_fails_on_nonexistent_data
    font = Font.load('data/font/3x5', 'txf')
    assert_raises(Errno::ENOENT) do
      font.get('foo')
    end
  end
end
