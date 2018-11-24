require 'minitest/autorun'
require 'yaml'

require_relative '../lib/marquee.rb'

class MarqueeTest < Minitest::Test
  TEST_STRING = "hello"

  def setup
    @font = Font.load('data/font/3x5', 'txf')
  end

  def test_each_letter_loops_letters
    marquee = Marquee.new(TEST_STRING, @font)
    letters = marquee.each_letter.first((TEST_STRING.length + 1) * 3)
    assert letters == ((TEST_STRING + "\t") * 3).split(//)
  end

  def test_no_repeat_letters
    marquee = Marquee.new(TEST_STRING, @font)
    letters = marquee.each_letter(repeat: false).first((TEST_STRING.length + 1) * 3)
    assert letters == (TEST_STRING).split(//)
  end

  def test_each_colum
    marquee = Marquee.new(TEST_STRING, @font)
    columns = marquee.each_column.first(100)
    reference = YAML.load(File.read("tst/fixtures/hello_columns_100.yml"))
    assert columns == reference

    no_repeat_columns = marquee.each_column(repeat: false).first(100)
    assert no_repeat_columns.length < columns.length
  end
end
