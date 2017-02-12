require 'test_helper'
require 'resampling'
require 'chunky_png'

filename = "test/monkey.png"

describe Image do

  describe "#load" do
    it "load a file" do
      image = Image.new
      image.load(filename)
      image_expected = ChunkyPNG::Image.from_file(filename)
      image.data.eql?(image_expected).must_equal(true)
    end
  end

  describe "#save" do
    it "save a file" do
      image = Image.new
      image.load(filename)
      image.save("test.png")
      image_expected = ChunkyPNG::Image.from_file("test.png")
      image.data.eql?(image_expected).must_equal(true)
    end
  end

  describe "#each_coordinates" do
    it "iterate through pixel coordinates" do
      image = Image.new
      image.load(filename)
      image_expected = ChunkyPNG::Image.from_file(filename)
      image.each_coordinates do |c|
          image_expected.get_pixel(c[0],c[1]).must_equal(image.data[c[0],c[1]])
      end
    end
  end

  describe "#set_pixel" do
    it "set_pixel" do
      image = Image.new
      image.load(filename)
      newcolor = ChunkyPNG::Color.rgb(1,2,3)
      image.set_pixel( [0,0], newcolor )
      image.data.pixels[0].must_equal(newcolor)
    end
  end

end
