require_relative 'font.rb'

class Marquee
  class Options
    attr_accessor :letter_spacing, :tab_spacing
    def initialize
      @letter_spacing = 1
      @tab_spacing = 4
    end
  end

  include Enumerable

  def initialize(string, font, options = Marquee::Options.new)
    @options = options
    @string = string
    @font = font
    @string.length > 0 or raise ArgumentError, "Must provide non-zero length string"
  end

  def each_column(&blk)
    return enum_for(:each_column) unless block_given?
    ii = 0
    each_letter do |letter|
      if letter == "\t"
        # TODO: determine column length from font
        yield_tab_spacing(5, &blk)
      else
        columns = @font.get(letter).transpose
        yield_letter_columns(columns, &blk)
        yield_letter_spacing(columns.first.length, &blk)
      end
    end
  end

  def each_letter
    return enum_for(:each_letter) unless block_given?
    ii = 0
    loop do
      yield @string[ii]
      ii = (ii + 1) % @string.length
      yield "\t" if ii == 0
    end
  end

  private

  def yield_letter_columns(columns)
    columns.each do |column|
      yield column
    end
  end

  def yield_letter_spacing(column_length)
    @options.letter_spacing.times do
      yield [0] * column_length
    end
  end

  def yield_tab_spacing(column_length)
    @options.tab_spacing.times do
      yield [0] * column_length
    end
  end

end
