# encoding: UTF-8

require_relative "../test_helper"

class HashExtensionTest < TestCase
  def test_special_chars
    assert_equal 'a="&#0000;"', {'a' => "\0"}.to_attrs
    assert_equal 'a="\\\\"', {'a' => "\\"}.to_attrs
    assert_equal 'a="\\\\0"', {'a' => "\\0"}.to_attrs
    assert_equal 'a="\\\\&#0000;"', {'a' => "\\\0"}.to_attrs
  end
end
