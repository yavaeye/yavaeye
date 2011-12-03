require_relative '../test_helper'

class YavaUtilsTest < TestCase
  include YavaUtils

  def test_hot_value
    assert_equal true, hot_value(1, Time.now) > hot_value(1, Time.new(2011,7,3))
    assert_equal true, hot_value(10, Time.now) > hot_value(1, Time.now)
  end

  def test_boot_timestamp
    assert boot_timestamp <= Time.now.to_i
  end
end
