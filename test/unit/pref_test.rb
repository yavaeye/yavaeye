require_relative "../test_helper"

class PrefTest < TestCase
  def test_admin_password
    assert !Pref.initialized?
    assert !(Pref.validate_admin_password '')
    assert !(Pref.validate_admin_password nil)

    Pref.admin_password = 'hello'
    assert Pref.initialized?
    assert (Pref.validate_admin_password 'hello')
    assert !(Pref.validate_admin_password '')
    assert !(Pref.validate_admin_password nil)
  end
end
