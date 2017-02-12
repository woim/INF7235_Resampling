class Image
  attr_reader :data

  def load(filename)
    @data = ChunkyPNG::Image.from_file(filename)
  end

  def save(filename)
    @data.save(filename)
  end

  def each_coordinates
    @data.height.times do |i|
      @data.width.times do |j|
        yield [i,j]
      end
    end
  end

  def set_pixel( coord, color )
    @data.set_pixel( coord[0], coord[1], color)
  end

end
