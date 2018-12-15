require 'date'

require_relative 'font.rb'
require_relative 'marquee.rb'

class Hackr
  def initialize(string = "hack the planet", start_date = Date.parse('2018-01-01'))
    @string = string
    @today = Date.today
    @start_date = start_date
    @font = build_font
    @marquee = build_marquee(@string, @font)
  end

  def current_value
    if day == 0 || day == 6
      return 0
    else
      return @marquee.get_column(marquee_column)[day]
    end
  end

  def marquee_column
    week
  end

  def marquee_row
    return nil if [0, 6].include?(day)
    return wday - 1
  end

  def week
    ((@today - @start_date) / 7).to_i
  end

  def day
    @today.wday
  end

  private

  def build_font
    Font.load('data/font/3x5', 'txf')
  end

  def build_marquee(string, font)
    Marquee.new(string, font)
  end
end
