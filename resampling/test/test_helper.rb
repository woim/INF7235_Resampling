gem 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'matrix'
require 'chunky_png'
require 'pruby'


class Object
  def _describe( test )
    puts "--- On saute les tests pour \"#{test}\" ---"
  end

  def _it( test )
    puts "--- On saute le test \"#{test}\" ---"
  end
end
