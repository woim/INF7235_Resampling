class Image
  attr_reader :data
  attr_reader :samples

  def initialize
    @data = nil
    @samples = []
  end

  def load( filename )
    @data = ChunkyPNG::Image.from_file(filename)
    create_samples
  end

  def save( filename )
    fail "No image to save" unless @data != nil
    @data.save(filename)
  end

  def create_image( width, height )
    @data = ChunkyPNG::Image.new( width, height, ChunkyPNG::Color::TRANSPARENT)
    create_samples
  end

  def set_pixel( coord, color )
    @data.set_pixel( coord[0], coord[1], color )
  end

  def interpolate( coord )
    return 0 unless point_inside?( coord )
    neighbors = get_neighbors( coord )
    ChunkyPNG::Color.rgb( bilinear_interpolation( coord, neighbors.map { |e| e[0] } ), \
                          bilinear_interpolation( coord, neighbors.map { |e| e[1] } ), \
                          bilinear_interpolation( coord, neighbors.map { |e| e[2] } ) )
  end

  def point_inside?( coord )
    coord[0] >= 0.0 && coord[0] < @data.height-1 && coord[1] >= 0.0 && coord[1] < @data.width - 1
  end

  private

  def create_samples
    @data.height.times do |i|
      @data.width.times do |j|
        @samples.push( [i,j] )
      end
    end
  end

  def get_neighbors( coord )
    integer_coord = coord.map { |e| e.to_int }
    [ ChunkyPNG::Color.to_truecolor_bytes( @data.get_pixel( integer_coord[0], integer_coord[1] ) ),
      ChunkyPNG::Color.to_truecolor_bytes( @data.get_pixel( integer_coord[0], integer_coord[1]+1 ) ),
      ChunkyPNG::Color.to_truecolor_bytes( @data.get_pixel( integer_coord[0]+1, integer_coord[1] ) ),
      ChunkyPNG::Color.to_truecolor_bytes( @data.get_pixel( integer_coord[0]+1, integer_coord[1]+1 ) ) ]
  end

  def bilinear_interpolation( coord, neighbors )
    # wikipedia article on bilinear interpolation
    # https://en.wikipedia.org/wiki/Bilinear_interpolation
    integer_coord = coord.map { |e| e.to_int }
    x = coord[0] - integer_coord[0]
    y = coord[1] - integer_coord[1]
    x_vector = Matrix[ [1-x, x] ]
    neighbors_matrix = Matrix[  [neighbors[0], neighbors[1]], \
                                [neighbors[2], neighbors[3]] ]
    y_vector = Matrix[ [1-y, y] ].transpose
    value = x_vector * neighbors_matrix * y_vector
    color_canal = value[0,0].to_int
    color_canal = ( color_canal > 255 ) ? 255 : color_canal
    color_canal = ( color_canal < 0 ) ? 0 : color_canal
  end

end
