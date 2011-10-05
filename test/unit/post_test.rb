require_relative '../test_helper'

class PostTest < TestCase
  def setup
    2.times.each do |i|
      User.create!(openid: "#{i}@gmail.com", nick: "#{i}_i")
    end
    User.first.boards.create!(slug: "start", name: "stop", description: "nothing")
  end

  def test_post_with_link
    post = User.last.posts.create(title: "post", link: "123.com", board: Board.first)
    assert_equal false, post.errors.blank?
    post = User.last.posts.create(title: "post", link: "http://localhost:8080", board: Board.first)
    assert_equal true, post.errors.blank?
  end

  def test_post_combine_content_and_link
    post = User.last.posts.create(title: "post", link: "http://123.com", content: "123", board: Board.first)
    assert_equal false, post.errors.blank?
    post = User.last.posts.create(title: "post", board: Board.first)
    assert_equal false, post.errors.blank?
  end

  def test_karma_with_post
    User.last.posts.create!(title: "post", content: "nothing", board: Board.first)
    assert_equal 3, User.last.karma
    Post.first.destroy
    assert_equal 0, User.last.karma
  end

  def test_websit_with_link
    post = User.last.posts.create(title: "post", link: "http://123.com", board: Board.first)
    assert_equal "123.com", post.website
    post = User.last.posts.create(title: "post", link: "ftp://comp.cn:8080", board: Board.first)
    assert_equal "comp.cn:8080", post.website
  end
end

