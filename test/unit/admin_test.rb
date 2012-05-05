require_relative "../test_helper"

class AdminTest < TestCase
  def test_password
    assert !Admin.initialized?
    assert !(Admin.validate_password '')
    assert !(Admin.validate_password nil)

    Admin.password = 'hello'
    assert Admin.initialized?
    assert (Admin.validate_password 'hello')
    assert !(Admin.validate_password '')
    assert !(Admin.validate_password nil)
  end
end
