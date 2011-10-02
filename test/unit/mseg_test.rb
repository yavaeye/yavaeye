require_relative '../test_helper'
require 'set'

class Mseg_test < Test::Unit::TestCase

  def test_segment
    assert_equal Set["ab", "bc", "a", "b", "c"], Set.new(Mseg.segment "Ab Bc" )
  end
end

