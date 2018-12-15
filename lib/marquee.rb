require_relative 'font.rb'

class Marquee
  class Options
    attr_accessor :letter_spacing, :space_spacing, :tab_spacing
    def initialize
      @letter_spacing = 1
      @space_spacing = 3
      @tab_spacing = 4
    end
  end

  def initialize(string, font, options = Marquee::Options.new)
    @options = options
    @string = string
    @font = font
    @string.length > 0 or raise ArgumentError, "Must provide non-zero length string"

    @font_cache = {}

    preload_letters
  end

  def each_column(repeat: true, &blk)
    return enum_for(:each_column, repeat: repeat) unless block_given?
    each_letter(repeat: repeat) do |letter|
      if letter == "\t"
        yield_tab_spacing(&blk)
      elsif letter == " "
        yield_space(&blk)
      else
        columns = get_letter(letter)
        yield_letter_columns(columns, &blk)
        yield_letter_spacing(&blk)
      end
    end
  end

  def each_letter(repeat: true)
    return enum_for(:each_letter, repeat: repeat) unless block_given?
    loop do
      @string.each_char do |letter|
        yield letter
      end
      break if !repeat
      yield "\t"
    end
  end

  def get_column(n, repeat: true)
    each_column(repeat: repeat).first(n + 1).last
  end

  private

  def get_letter(letter)
    @font_cache[letter] ||= @font.get(letter).transpose
  end

  def yield_letter_columns(columns)
    columns.each do |column|
      yield column
    end
  end

  def yield_letter_spacing
    @options.letter_spacing.times do
      yield [0] * @font.height
    end
  end

  def yield_space
    @options.space_spacing.times do
      yield [0] * @font.height
    end
  end

  def yield_tab_spacing
    @options.tab_spacing.times do
      yield [0] * @font.height
    end
  end

  def preload_letters
    each_letter(repeat: false).lazy.reject{|ltr| /\s/ =~ ltr}.each do |letter|
      get_letter(letter)
    end
  end

end
