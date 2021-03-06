require 'minitest/autorun'
require 'yaml'

require_relative '../lib/marquee.rb'

class MarqueeTest < Minitest::Test
  TEST_STRING = "hello world"

  class << self
    def update_fixtures
      font = Font.load('data/font/3x5', 'txf')
      marquee = Marquee.new(TEST_STRING, font)
      columns = marquee.each_column.first(100)
      File.open("tst/fixtures/hello_columns_100.yml", 'w') do |file|
        file.puts YAML.dump(columns)
      end
    end
  end

  def setup
    @font = Font.load('data/font/3x5', 'txf')
  end

  def test_get_column
    marquee = Marquee.new(TEST_STRING, @font)
    column = marquee.get_column(10)
    reference = YAML.load(File.read("tst/fixtures/hello_columns_100.yml"))
    assert column == reference[10]
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

  def test_long_string
    marquee = Marquee.new(really_long_string, @font)
    10.times do
      marquee.each_column(repeat: false) do |x|
      end
    end
  end

  private

  def really_long_string
    10000.times.map{('a'..'z').to_a.sample}.join
  end

end
