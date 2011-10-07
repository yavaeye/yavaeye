require_relative '../test_helper'

class HotTest < TestCase

  def test_hot_value
    assert_equal true, Hot.value(1, Time.now) > Hot.value(1, Time.new(2011,7,3))
    assert_equal true, Hot.value(10, Time.now) > Hot.value(1, Time.now)
  end
end

