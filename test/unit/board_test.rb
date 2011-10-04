require_relative '../test_helper'

class BoardTest < TestCase
  def setup
    User.create!(openid: "yavaeye@gmail.com", nick: "0_i")
    User.first.boards.create!(slug: "start", name: "stop", description: "nothing")
  end

  def test_verified_with_mention
    b = Board.first
    b.update_attributes!(active: true)
    assert_equal true, b.active
    assert_equal 1, b.user.messages.to_a.size
    assert_equal "founder", b.user.messages.to_a.first.type
  end
end

