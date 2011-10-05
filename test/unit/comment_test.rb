require_relative '../test_helper'

class CommentTest < TestCase
  def setup
    3.times.each do |i|
      User.create!(openid: "#{i}@gmail.com", nick: "#{i}_i")
    end
    User.first.boards.create!(slug: "start", name: "stop", description: "nothing")
    User.first.boards.create!(slug: "stop", name: "start", description: "nothing")
    User.first.posts.create!(title: "post", content: "nothing", board: Board.first)
  end

  def test_karma_with_reply
    Comment.create!(content: "comment", user: User.last, post: Post.last)
    assert_equal 1, User.last.karma
    Comment.first.destroy
    assert_equal 0, User.last.karma
  end

  def test_reply_post
    Comment.create!(content: "comment", user: User.last, post: Post.last)
    assert_equal 1, User.first.mentions.to_a.size
    assert_equal "post", User.first.mentions.to_a.first.type
  end

  def test_reply_merge_mention
    Comment.create!(content: "comment", user: User.last, post: Post.last)
    Comment.create!(content: "comment", user: User.all[User.all.size/2], post: Post.last)
    assert_equal 1, User.first.mentions.to_a.size
    assert_equal 2, User.first.mentions.first.triggers.size
  end

  def test_reply_by_himself
    Comment.create!(content: "comment", user: User.first, post: Post.last)
    assert_equal 0, User.first.mentions.to_a.size
  end

  def test_reply_mention_from_other_user
    Comment.create!(content: "comment", user: User.last, post: Post.last)
    assert_equal 0, User.last.messages.to_a.size
    Comment.create!(content: "comment", user: User.all[User.all.size/2], post: Post.last)
    assert_equal 2, Comment.all.size
    assert_equal 1, User.last.mentions.to_a.size
    assert_equal User.all[User.all.size/2].nick, User.last.mentions.to_a.first.triggers.first
    assert_equal "reply", User.last.mentions.to_a.first.type
  end

end

