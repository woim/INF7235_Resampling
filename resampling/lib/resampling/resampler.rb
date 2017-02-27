class Resampler
  attr_accessor :source_filename
  attr_accessor :image_source
  attr_accessor :image_destination
  attr_accessor :transform
	attr_accessor :nb_threads
  attr_reader   :slice_index

  def self.create
    resampler = new
    yield resampler
    resampler.create_images
    resampler
  end

  def process_sequential
    process( @image_destination.samples ) 
  end

  def process_pcall( nb_threads = PRuby.nb_threads )
	  set_nb_threads( nb_threads )
    set_slices_index
    PRuby.pcall(	0...@nb_threads, 
						     	lambda do |t|
                    index = @slice_index[t]
  	                samples = @image_destination.samples.slice( index[0],index[1] )
	  								process( samples )
	 	     					end
		   				 ) 
  end

  def process_peach( nb_threads = PRuby.nb_threads )
    set_nb_threads( nb_threads )
    image_destination.samples.peach( nb_threads: @nb_threads ) do |s|
      interpolate( s )
    end
  end

  def process_peach_dynamic( granularity = 1 )
    set_nb_threads( PRuby.nb_threads )
    image_destination.samples.peach( dynamic: granularity ) do |s|
      interpolate( s )
    end
  end

  def create_images
    @image_source.load( @source_filename ) 
    @image_destination.create_image( 
                            @image_source.data.width, 
                            @image_source.data.height
                                   )
  end

	def process( samples )
		samples.each do |p|
      interpolate( p )
    end 
	end

  def interpolate( p )
    src_coord = @transform.transform_point( p )
    @image_destination.set_pixel( p, @image_source.interpolate( src_coord ) )
  end

  def set_nb_threads( nb_threads )
    @nb_threads = ( nb_threads > @image_destination.samples.size ) ? \
                      @iage_destination.smaples.size : nb_threads 
  end

  def set_slices_index
 	  @slice_index = []
    start = 0
    remainder = @image_destination.samples.size % @nb_threads
		(0...@nb_threads).each do |t|
      size = @image_destination.samples.size / @nb_threads
      size += 1 if remainder > 0
      @slice_index.push( [start,size] )
      start += size
      remainder -= 1 if remainder > 0
    end
	end

end
