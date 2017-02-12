class Transform
  attr_reader :rotation
  attr_reader :translation
  attr_reader :matrix

  def initialize( rotation, translation )
    @matrix = Matrix.identity(3)
    @rotation = deg_to_rad( rotation )
    @translation = translation
    compute_matrix
  end

  def transform_point( coord )
    @matrix * Matrix[ coord + [1] ].transpose
  end

  private

  def compute_matrix
    # We directly compute the inverse matrix
    # X = R'(Y - t) = R'Y - R't
    rotation = Matrix[ [Math.cos(@rotation) , -Math.sin(@rotation)], \
                       [Math.sin(@rotation) ,  Math.cos(@rotation)] ]
    inverse_rotation = rotation.transpose
    inverse_translation = inverse_rotation * Matrix[@translation].transpose
    @matrix = Matrix[ [inverse_rotation[0,0], inverse_rotation[0,1], inverse_translation[0,0]], \
                      [inverse_rotation[1,0], inverse_rotation[1,1], inverse_translation[1,0]] ]
  end

  def deg_to_rad( degrees )
    degrees * Math::PI / 180
  end

end
