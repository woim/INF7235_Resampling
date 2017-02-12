class Resampler
  attr_accessor :source_filename
  attr_accessor :image_source
  attr_accessor :image_destination
  attr_accessor :transform

  def self.create
    resampler = new
    yield resampler
    resampler.create_images
    resampler
  end

  def process()
    @image_destination.each_coordinates do |p|
      src_coord = @transform.transform_point(p)
      @image_destination.set_pixel( p, @image_source.interpolate( src_coord ) )
    end
  end

  def create_images
    @image_source.load(@source_filename)
    @image_destination.create_image( @image_source.data.width, @image_source.data.height )
  end

end
