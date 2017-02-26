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
	  @nb_threads = ( nb_threads > @image_destination.samples.size ) ? \
                    @iage_destination.smaples.size : nb_threads  
    define_slice_index
    puts "nb_threads: " + @nb_threads.to_s 
    puts "size image " + @image_destination.samples.size.to_s
    puts @slice_index.to_s 
    #PRuby.pcall(	0...@nb_threads, 
		#				     	lambda do |t|
    #                index = @slice_index[t]
  	#                samples = @image_destination.samples.slice( index[0],index[1] )
	  #								process( samples )
	 	#     					end
		#   				 )
  end

  def create_images
    @image_source.load(@source_filename)
    @image_destination.create_image( @image_source.data.width, @image_source.data.height )
  end

	private 

	def process( samples )
		samples.each do |p|
    	src_coord = @transform.transform_point(p)
      @image_destination.set_pixel( p, @image_source.interpolate( src_coord ) )
    end 
	end

	def define_slice_index
 	  remainder = @image_destination.samples.size % @nb_threads
    length = ( @image_destination.samples.size / @nb_threads )
    (0...@nb_threads).each do |t|
		  length += 1 if remainder != 0
      start = t*(length+1)
      @slice_index.push( [start,lenghth] )
      remainder -= 1
    end
	    #puts remainder.to_s  + " " + index_thread.to_s + " " + start.to_s + " " + length.to_s
	end

end
