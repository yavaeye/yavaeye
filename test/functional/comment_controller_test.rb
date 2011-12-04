# encoding: UTF-8

require_relative "../test_helper"

class CommentControllerTest < FunctionalTestCase

  def setup
    login
    @post = Factory(:post)
  end

  def test_show_comments
    make_comment
    get "/post/#{@post.token}"
    assert_equal 200, status
    text = css(".post-comments .comment-block").children.first.text
    assert_equal "hello world", text
  end

  def delete_comment
    comment = make_comment
    delete "/comment/#{comment._id}"
    assert_equal 0, Post.first.comments.size
  end

  def build_comment
    comment = Comment.new(content: "hello world")
    comment.post = @post
    comment.user = @user
    comment
  end

  def make_comment
    build_comment.save!
  end
end
