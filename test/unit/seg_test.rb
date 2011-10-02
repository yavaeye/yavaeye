require_relative '../test_helper'
require 'set'

class SegTest < Test::Unit::TestCase

  def test_segment
    assert_equal Set["ab", "bc", "a", "b", "c"], Set.new(Seg.segment "Ab Bc" )
  end
end

