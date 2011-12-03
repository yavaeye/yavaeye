require_relative '../test_helper'

class PostTest < TestCase
  def setup
    2.times.each do |i|
      Factory(:user)
    end
    User.first.boards.create!(name: "start", active: true, description: "nothing")
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

  def test_domain_with_post
    post = User.last.posts.create(title: "post", link: "http://123.com", board: Board.first)
    assert_equal "123.com", post.domain
    post = User.last.posts.create(title: "post", link: "ftp://comp.cn:8080", board: Board.first)
    assert_equal "comp.cn:8080", post.domain
    post = User.last.posts.create(title: "post", content: "self post", board: Board.first)
    assert_equal "self.start", post.domain
  end

  def test_dislikers_on_post
    post = User.last.posts.create(title: "post", link: "http://123.com", board: Board.first)
    User.first.dislike post._id
    assert_equal User.first.nick, Post.first.dislikers.to_a.first.nick
  end

  def test_markers_on_post
    post = User.last.posts.create(title: "post", link: "http://123.com", board: Board.first)
    User.first.mark post._id
    assert_equal User.first.nick, Post.first.markers.to_a.first.nick
  end

  def test_score_on_post
    User.last.posts.create(title: "post", link: "http://123.com", created_at: Time.now-100 ,board: Board.first)
    User.last.posts.create(title: "post", link: "http://123.com", board: Board.first)
    assert_equal true, Post.last.score > Post.first.score
  end
end

