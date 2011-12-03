require_relative '../test_helper'

class UserTest < TestCase
  def setup
    3.times.each do |i|
      User.create!(email: "#{i}@gmail.com", nick: "#{i}_i")
    end
    User.first.boards.create!(name: "stop", active: true, description: "nothing")
    User.first.boards.create!(name: "start", active: true, description: "nothing")
  end

  def test_last_posts
    6.times.each do |i|
      post = Post.create(title: "post#{i}", content: "#{i}", user: User.first, board: Board.first)
    end
    assert_equal 5, User.first.last_posts.to_a.size
  end

  def test_last_comments
    post = Post.create(title: "post", content: "this is a post", user: User.first, board: Board.first)
    6.times.each do |i|
      comment = Comment.create(title: "post#{i}", content: "#{i}", user: User.first, post: Post.first)
    end
    assert_equal 5, User.first.last_comments.to_a.size
  end

  def test_deliver
    User.first.deliver SentMessage.new(to: User.last.nick, text: "hello text")
    assert_equal 1, User.first.sent_messages.size
    assert_equal 1, User.last.received_messages.size
  end

  def test_receive
    User.first.deliver SentMessage.new(to: User.last.nick, text: "hello text")
    User.last.receive User.last.received_messages.first
    assert_equal 1, User.last.received_messages.size
    assert_equal true, User.last.received_messages.first.read
  end

  def test_unfollow
    User.first.unfollow(User.last._id)
    assert_equal 1, User.first.unfollowing_ids.size
    assert_equal 1, User.last.unfollower_ids.size
    assert_equal 1, User.last.mentions.size
    assert_equal User.first.nick, User.last.mentions.to_a.first.triggers.first
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
    Board.all.each {|b| User.first.unsubscribe(b.name) }
    assert_equal 2, User.first.unsubscribes.size
    assert_equal 2, User.first.mentions.size
    assert_equal User.first.nick, User.first.mentions.to_a.first.triggers.first
  end

  def test_subscribe
    Board.all.each {|b| User.first.unsubscribe(b.name) }
    User.first.subscribe Board.first.name
    assert_equal 1, User.first.unsubscribes.size
    User.first.subscribe Board.last.name
    assert_equal 2, User.first.subscribes.size
  end

  def test_dislike
    post = Post.create(title: "post", content: "this is a post", user: User.last, board: Board.first)
    User.first.dislike post._id
    assert_equal User.first._id, Post.first.dislikes.to_a.first
    assert_equal 2.5, User.last.karma
  end

  def test_mark
    post = Post.create(title: "post", content: "this is a post", user: User.last, board: Board.first)
    User.first.mark post._id
    assert_equal 2, Post.first.marks.to_a.size
    assert_equal User.first.id, Post.first.marks.to_a.last
    assert_equal 3.5, User.last.karma
  end
end

