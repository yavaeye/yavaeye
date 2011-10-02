require_relative '../test_helper'

class UserTest < Test::Unit::TestCase
  def setup
    3.times.each do |i|
      User.create!(openid: "#{i}@gmail.com", nick: "#{i}_i")
    end
    2.times.each do |i|
      Board.create!(slug: "#{i}", name: "#{i}_i", founder: User.first.nick, description: "#{1}")
    end
  end

  def test_unfollow
    User.first.unfollow(User.last._id)
    assert_equal 1, User.first.unfollowing_ids.size
    assert_equal 1, User.last.unfollower_ids.size
  end

  def test_follow
    User.all.each{|u| User.first.unfollow(u._id)}
    User.first.follow User.last._id
    assert_equal 1, User.first.unfollowing_ids.size
    assert_equal 0, User.last.unfollower_ids.size
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

  def test_unsubscribe
    Board.all.each {|b| User.first.unsubscribe(b.slug) }
    assert_equal 2, User.first.unsubscribes.size
  end

  def test_subscribe
    Board.all.each {|b| User.first.unsubscribe(b.slug) }
    User.first.subscribe Board.first.slug
    assert_equal 1, User.first.unsubscribes.size
  end
end

