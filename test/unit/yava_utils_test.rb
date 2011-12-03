require_relative '../test_helper'

class YavaUtilsTest < TestCase

  def test_hot_value
    assert_equal true, YavaUtils.hot_value(1, Time.now) > YavaUtils.hot_value(1, Time.new(2011,7,3))
    assert_equal true, YavaUtils.hot_value(10, Time.now) > YavaUtils.hot_value(1, Time.now)
  end
end

