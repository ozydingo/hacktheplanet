require_relative 'font.rb'

class Marquee
  class Options
    attr_accessor :letter_spacing, :tab_spacing
    def initialize
      @letter_spacing = 1
      @tab_spacing = 4
    end
  end

  def initialize(string, font, options = Marquee::Options.new)
    @options = options
    @string = string
    @font = font
    @string.length > 0 or raise ArgumentError, "Must provide non-zero length string"
  end

  def each_column(&blk)
    return enum_for(:each_column) unless block_given?
    each_letter do |letter|
      if letter == "\t"
        yield_tab_spacing(&blk)
      else
        columns = @font.get(letter).transpose
        yield_letter_columns(columns, &blk)
        yield_letter_spacing(&blk)
      end
    end
  end

  def each_letter
    return enum_for(:each_letter) unless block_given?
    loop do
      @string.each_char do |letter|
        yield letter
      end
      yield "\t"
    end
  end

  private

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

  def yield_tab_spacing
    @options.tab_spacing.times do
      yield [0] * @font.height
    end
  end

end
