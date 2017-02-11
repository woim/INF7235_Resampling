class image
  attr_reader :image

  def load(filename)
    image = ChunkyPNG::Image.from_file(filename)
  end

  def save(filename)
    image.save(filename)
  end

  def pixels_coordinates
    image.height.times do |i|
      image.width.times do |j|
        yield [i,j]
      end
    end
  end

  def set_pixel( coord, color )
    image.set_pixel( coord[0], coord[1], color)
  end
  
end
