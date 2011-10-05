require_relative '../test_helper'

class PostTest < TestCase
  def setup
    2.times.each do |i|
      User.create!(openid: "#{i}@gmail.com", nick: "#{i}_i")
    end
    User.first.boards.create!(slug: "start", name: "stop", description: "nothing")
  end

  def test_karma_with_post
    User.last.posts.create!(title: "post", content: "nothing", board: Board.first)
    assert_equal 3, User.last.karma
    Post.first.destroy
    assert_equal 0, User.last.karma
  end
end

