require_relative '../test_helper'

class CommentTest < TestCase
  def setup
    @man = create :user
    @woman = create :user
    @middle = create :user
    @post = @woman.posts.create!(title: "post", content: "nothing")
  end

  def test_karma_with_reply
    comment = @post.comments.create!(content: "comment", user: @man)
    assert_equal 3.5, @woman.reload.karma
    comment.destroy
    assert_equal 3, @woman.reload.karma
  end

  def test_karma_with_reply_by_himself
    comment = @post.comments.create!(content: "comment", user: @woman)
    assert_equal 3, @woman.reload.karma
    comment.destroy
    assert_equal 3, @woman.reload.karma
  end

  def test_mention_with_reply
    comment = @post.comments.create!(content: "comment", user: @man)
    assert_equal 1, @woman.mentions.size
  end
end
