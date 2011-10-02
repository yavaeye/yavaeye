require_relative '../test_helper'

class UserTest < Test::Unit::TestCase
  def setup
    3.times.each do |i|
      User.create!(openid: "#{i}@gmail.com", nick: "#{i}_i")
    end
  end

  def test_unfollow
    User.first.unfollow(User.last._id)
    assert_equal 1, User.first.unfollowing_ids.size
    assert_equal 1, User.last.unfollower_ids.size
  end

  def test_unfollow_him_self
    User.first.unfollow(User.first._id)
    assert_equal 0, User.first.unfollowing_ids.size
  end

  def test_get_unfollowings
    User.all.each {|u| User.first.unfollow(u._id)}
    assert_equal 2, User.first.unfollowings.to_a.size
  end

  def test_get_unfollowers
    User.all.each {|u| u.unfollow(User.last._id)}
    assert_equal 2, User.last.unfollowers.to_a.size
  end
end

