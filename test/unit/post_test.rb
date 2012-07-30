require_relative '../test_helper'

class PostTest < TestCase
  def setup
    @man = create :user
    @women = create :user
  end

  def test_post_with_link
    post = @man.posts.build(title: "post", link: "123.com")
    assert_equal false, post.valid?
    post = @man.posts.build(title: "post", link: "http://localhost:8080")
    assert_equal true, post.valid?
  end

  def test_post_combine_content_and_link
    post = @man.posts.build(title: "post", link: "http://123.com", content: "123")
    assert_equal false, post.valid?
    post = @man.posts.build(title: "post")
    assert_equal false, post.valid?
  end

  def test_karma_with_post
    post = @man.posts.create!(title: "post", content: "nothing")
    @man.reload
    assert_equal 3, @man.karma
    post.destroy
    @man.reload
    assert_equal 0, @man.karma
  end

  def test_domain_with_post
    post = @man.posts.create(title: "post", link: "http://123.com")
    assert_equal "123.com", post.domain
    post = @man.posts.create(title: "post", link: "ftp://comp.cn:8080")
    assert_equal "comp.cn:8080", post.domain
    post = @man.posts.create(title: "post", content: "self post")
    assert_equal "yavaeye.com", post.domain
  end

  def test_score_on_post
    early_post = @man.posts.create(title: "post", link: "http://123.com", created_at: Time.now-100)
    later_post = @man.posts.create(title: "post", link: "http://123.com")
    assert_equal true, later_post.score > early_post.score
  end

  def test_paginate_on_post
    10.times.each{|i| create :post }
    assert_equal 10, Post.all.size
    assert_equal 5, Post.paginate(1, 5).to_a.size
  end
end
