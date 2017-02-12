class Transform
  attr_accessor :rotation
  attr_accessor :translation
  attr_reader   :matrix

  def initialize(rotation, translation)
    matrix.identity(3)
  end

  def compute_matrix()
    # We directly compute the inverse matrix
    matrix[0][0] = cos(rotation)
    matrix[0][1] = -sin(rotation)
    matrix[0][2] = translation[0]
    matrix[1][0] = sin(rotation)
    matrix[1][1] = cos(rotation)
    matrix[1][2] = translation[1]
  end

  def transform_point(coord)
    matrix*matrix[coord]
  end
end
