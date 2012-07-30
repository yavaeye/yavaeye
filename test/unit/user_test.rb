require_relative "../test_helper"

class UserTest < TestCase
  def setup
    @user = create :user
    @post = create :post
    20.times.each{ |i| create :mention, user: @user }
  end

  def test_read_mentions
    assert_equal 20, @user.mentions.unread.size
    @user.read_mentions
    @user.reload
    assert_equal 0, @user.mentions.unread.size
  end

  def test_user_mentions_paginate
    assert_equal 10, @user.mentions.paginate(1, 10).to_a.size
  end

  def test_like_unlike
    @user.like @post
    assert_equal 1, @user.liked_posts.size
    assert_equal 1, @post.liker_count

    @user.unlike @post
    @user.reload
    assert_equal 0, @user.liked_posts.size
    assert_equal 0, @post.liker_count
  end

  def test_read_unread
    @user.read @post
    @user.profile.reload
    assert_equal 1, @user.profile.read_post_ids.size
    assert_equal 1, @post.reader_count

    @user.unread @post
    @user.profile.reload
    assert_equal 0, @user.profile.read_post_ids.size
    assert_equal 0, @post.reader_count
  end

  def test_mark_unmark
    @user.mark @post
    @user.profile.reload
    assert_equal 1, @user.profile.marked_post_ids.size
    assert_equal 1, @post.marker_count

    @user.unmark @post
    @user.profile.reload
    assert_equal 0, @user.profile.marked_post_ids.size
    assert_equal 0, @post.marker_count
  end
end
