# encoding: UTF-8

require_relative "../test_helper"

class CoreExtensionTest < TestCase
  def test_hash_to_attrs
    # special chars
    assert_equal 'a="&#0000;"', {'a' => "\0"}.to_attrs
    assert_equal 'a="\\\\"', {'a' => "\\"}.to_attrs
    assert_equal 'a="\\\\0"', {'a' => "\\0"}.to_attrs
    assert_equal 'a="\\\\&#0000;"', {'a' => "\\\0"}.to_attrs
  end

  def test_mongoid_document_classes
    Module.mongoid_document_classes
  end
end
