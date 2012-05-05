require_relative '../test_helper'

class CommentTest < TestCase
  def setup
    @man = FactoryGirl.create(:user)
    @women = FactoryGirl.create(:user)
    @middle = FactoryGirl.create(:user)
    @post = @women.posts.create!(title: "post", content: "nothing")
  end

  def test_karma_with_reply
    comment = Comment.create!(content: "comment", author: @man, post: @post)
    assert_equal 3.5, @women.karma
    comment.destroy
    assert_equal 3, @women.karma
  end

  def test_karma_with_reply_by_himself
    comment = Comment.create!(content: "comment", author: @women, post: @post)
    assert_equal 3, @women.karma
    comment.destroy
    assert_equal 3, @women.karma
  end

  def test_mention_with_reply
    comment = Comment.create!(content: "comment", author: @man, post: @post)
    assert_equal 1, @women.mentions.size
  end
end
