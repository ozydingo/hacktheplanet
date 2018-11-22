class Font
  class << self
    private :new

    def load(path, format)
      new(path, format)
    end
  end

  def initialize(path, format)
    @path = path
    @format = format

    File.directory?(@path) or raise Errno::ENOENT, "Path must be a valid directory"
  end

  def get(letter)
    parse(File.read(File.join(@path, "#{letter}.#{@format}")))
  end

  def parse(file_data)
    file_data.split("\n").map{|line| line.split(//).map(&:to_i)}
  end
end
