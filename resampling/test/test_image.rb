require 'test_helper'
require 'resampling'

filename = "test/monkey.png"

describe Image do

  describe "#load" do
    it "load a file" do
      image = Image.new
      image.load( filename )
      image_expected = ChunkyPNG::Image.from_file(filename)
      image.data.eql?(image_expected).must_equal(true)
    end
  end

  describe "#save" do
    it "save a file" do
      image = Image.new
      image.load( filename )
      image.save("test.png")
      image_expected = ChunkyPNG::Image.from_file("test.png")
      image.data.eql?(image_expected).must_equal(true)
    end
  end

  describe "#samples" do
    it "iterate through pixel coordinates" do
      image = Image.new
      image.load( filename )
      image_expected = ChunkyPNG::Image.from_file(filename)
      image.samples.each do |c|
          image_expected.get_pixel(c[0],c[1]).must_equal(image.data[c[0],c[1]])
      end
    end
  end

  describe "#set_pixel" do
    it "set_pixel" do
      image = Image.new
      image.load( filename )
      newcolor = ChunkyPNG::Color.rgb(1,2,3)
      image.set_pixel( [0,0], newcolor )
      image.data.pixels[0].must_equal(newcolor)
    end
  end

  describe "#interpolate" do
    it "interpolate non integer pixel" do
      image = Image.new
      image.load( filename )
      color = image.interpolate( [0.5,0.5] )
      image_expected = ChunkyPNG::Image.from_file(filename)
      neighbor = [  ChunkyPNG::Color.to_truecolor_bytes( image_expected.get_pixel( 0, 0 ) ),
                    ChunkyPNG::Color.to_truecolor_bytes( image_expected.get_pixel( 0, 1 ) ),
                    ChunkyPNG::Color.to_truecolor_bytes( image_expected.get_pixel( 1, 0 ) ),
                    ChunkyPNG::Color.to_truecolor_bytes( image_expected.get_pixel( 1, 1 ) ) ]
      r = neighbor.map { |e| e[0] }.inject{ |sum, el| sum + el }.to_f / 4
      g = neighbor.map { |e| e[1] }.inject{ |sum, el| sum + el }.to_f / 4
      b = neighbor.map { |e| e[2] }.inject{ |sum, el| sum + el }.to_f / 4
      color_expected = ChunkyPNG::Color.rgb( r.to_int, g.to_int, b.to_int )
      color.must_equal(color_expected)
    end
  end

end
