class Resampler
  attr_accessor :image
  attr_accessor :transform

  def process()
    image_dest.pixels_coordinates do |p|
      src_coord = transform.transform_point(p)
      imge_dest.set_pixel( p, image_source.interpolate( src_coord ) )
    end
  end

end
