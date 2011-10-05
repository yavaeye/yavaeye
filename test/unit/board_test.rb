require_relative '../test_helper'

class BoardTest < TestCase
  def setup
    User.create!(openid: "yavaeye@gmail.com", nick: "0_i")
    User.first.boards.create!(name: "start", description: "nothing")
  end

  def test_verified_with_mention
    b = Board.first
    b.update_attributes!(active: true)
    assert_equal true, b.active
    assert_equal 1, b.user.mentions.to_a.size
  end

  def test_karma_with_board
    assert_equal 10, User.first.karma
    Board.first.destroy
    assert_equal 0, User.first.karma
  end
end

