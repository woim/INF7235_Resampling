$LOAD_PATH.unshift('lib')
require_relative 'test_helper'
require 'resampling'

filename = "test/monkey.png"

describe Resampler do

  describe "#new" do
    it "create a resampler" do
      @resampler = Resampler.create do |r|
          r.source_filename = filename
          r.image_source = Image.new
          r.image_destination = Image.new
          r.transform = Transform.new(10,[-5,-5])
      end

      image_expected = ChunkyPNG::Image.from_file(filename)
      @resampler.image_source.data.eql?(image_expected).must_equal(true)

      @resampler.transform.rotation.must_equal(10 * Math::PI / 180)
      @resampler.transform.translation.must_equal([-5,-5])

      @resampler.image_destination.data.width.must_equal(image_expected.width)
      @resampler.image_destination.data.height.must_equal(image_expected.height)
    end
  end

  describe "#process_sequential" do
    it "verify that we catually properly resampler" do
      @resampler = Resampler.create do |r|
          r.source_filename = filename
          r.image_source = Image.new
          r.image_destination = Image.new
          r.transform = Transform.new(5,[0,0])
      end
      @resampler.process_sequential
      image_expected = ChunkyPNG::Image.from_file( filename )
      @resampler.image_destination.save("test_resampled.png")
      @resampler.image_destination.eql?(image_expected).must_equal(false)
    end
  end

  describe "#process_pcall" do
    it "verify that we catually properly resampler" do
      @resampler = Resampler.create do |r|
          r.source_filename = filename
          r.image_source = Image.new
          r.image_destination = Image.new
          r.transform = Transform.new(5,[0,0])
      end
      @resampler.process_pcall
      image_expected = ChunkyPNG::Image.from_file( filename )
      @resampler.image_destination.save("test_resampled.png")
      @resampler.image_destination.eql?(image_expected).must_equal(false)
    end
  end

  describe "#process_peach" do
    it "verify that we catually properly resampler" do
      @resampler = Resampler.create do |r|
          r.source_filename = filename
          r.image_source = Image.new
          r.image_destination = Image.new
          r.transform = Transform.new(5,[0,0])
      end
      @resampler.process_peach
      image_expected = ChunkyPNG::Image.from_file( filename )
      @resampler.image_destination.save("test_resampled.png")
      @resampler.image_destination.eql?(image_expected).must_equal(false)
    end
  end

#  describe "#process_peach_dynamic" do
#    it "verify that we catually properly resampler" do
#      @resampler = Resampler.create do |r|
#          r.source_filename = filename
#          r.image_source = Image.new
#          r.image_destination = Image.new
#          r.transform = Transform.new(5,[0,0])
#      end
#      @resampler.process_peach_dynamic
#      image_expected = ChunkyPNG::Image.from_file( filename )
#      @resampler.image_destination.save("test_resampled.png")
#      @resampler.image_destination.eql?(image_expected).must_equal(false)
#    end
#  end

  describe "#process_reduced_list" do
    it "verify that we catually properly resampler" do
      @resampler = Resampler.create do |r|
          r.source_filename = filename
          r.image_source = Image.new
          r.image_destination = Image.new
          r.transform = Transform.new(5,[0,0])
      end
      @resampler.process_reduced_list
      image_expected = ChunkyPNG::Image.from_file( filename )
      @resampler.image_destination.save("test_resampled.png")
      @resampler.image_destination.eql?(image_expected).must_equal(false)
    end
  end

end
