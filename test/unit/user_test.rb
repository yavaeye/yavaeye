require_relative "../test_helper"

class UserTest < TestCase
  def setup
    @user = FactoryGirl.create(:user)
    20.times.each{|i| FactoryGirl.create(:mention)}
  end

  def test_read_mentions
    assert_equal 20, @user.mentions.unread.to_a.size
    @user.read_mentions @user.mentions
    assert_equal 0, @user.mentions.unread.to_a.size
  end

  def test_user_mentions_paginate
    assert_equal 10, @user.mentions.paginate(1, 10).to_a.size
  end
end
