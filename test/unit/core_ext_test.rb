# encoding: UTF-8

require_relative "../test_helper"

class CoreExtTest < TestCase
  def test_hash_to_attrs
    # special chars
    assert_equal 'a="&#x0000;"', {'a' => "\0"}.to_attrs
    assert_equal 'a="\\\\"', {'a' => "\\"}.to_attrs
    assert_equal 'a="\\\\0"', {'a' => "\\0"}.to_attrs
    assert_equal 'a="\\\\&#x0000;"', {'a' => "\\\0"}.to_attrs

    # edge cases
    assert_equal '', {}.to_attrs

    # non-string types
    assert_equal %q|a="0" c="[]" d="{\"3\":\"there's something here\"}"|,
                {'a' => 0, 'b' => nil, 'c' => [], 'd' => {3 => "there's something here"}}.to_attrs
  end
end
