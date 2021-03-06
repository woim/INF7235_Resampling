$LOAD_PATH.unshift('lib')
require_relative 'test_helper'
require 'resampling'

describe Transform do

  describe "#transform_point" do
    it "correctly compute transformation" do
      transform = Transform.new(45,[-5,-5])
      point = [5,5]
      # X = R'(Y - t) = R'Y - R't
      angle = 0.785398
      rotation = Matrix[ [Math.cos(angle) , -Math.sin(angle)], \
                         [Math.sin(angle) ,  Math.cos(angle)] ]
      inverse_rotation = rotation.transpose
      inverse_translation = inverse_rotation * Matrix[ [-5,-5] ].transpose
      matrix = Matrix[ [inverse_rotation[0,0], inverse_rotation[0,1], inverse_translation[0,0]], \
                       [inverse_rotation[1,0], inverse_rotation[1,1], inverse_translation[1,0]] ]
      point_expected = matrix * Matrix[ point + [1] ].transpose
      coord_expected = [ point_expected[0,0], point_expected[1,0] ]
      transform.transform_point(point).must_equal( coord_expected )
    end
  end

end
