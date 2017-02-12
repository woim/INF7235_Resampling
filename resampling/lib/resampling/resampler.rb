class Resampler
  attr_accessor :image
  attr_accessor :transform
  attr_accessor :interpolator

  def process()
    image.pixels_coordinates do |p|
      src_coord = transform.transform_point(p)
      imge_dest.set_pixel( p, interpolator.interpolate(src_coord) )
    end
  end

end
