# encoding: UTF-8

require_relative "../test_helper"

class PostControllerTest < FunctionalTestCase
  def setup
    @user = Factory(:user)
    @logged_in_session = {'rack.session' => {'user_id' => @user.id.to_s, 'csrf' => 'random-string'}}

    @other_user = Factory.build(:user)
    @other_logged_in_session = {'rack.session' => {'user_id' => @other_user.id.to_s, 'csrf' => 'random-string'}}

    @board = Factory(:board)
  end

  def test_index
    make_post
    get '/'
    assert_equal 200, status
  end

  def test_new
    get '/post/new', {}, @logged_in_session
    assert_equal 200, status
  end

  def test_new_forbidden
    get '/post/new'
    assert_equal 302, status
  end

  def test_post

  end

  def test_show
    make_post
    get "/post/#{@post.token}"
    assert_equal 200, status
  end

  def test_edit_forbidden
    make_post
    get "/post/#{@post.token}/edit", {}, @other_logged_in_session
    assert_equal 302, status
  end

  def test_edit
    make_post
    get "/post/#{@post.token}/edit", {}, @logged_in_session
    assert_equal 200, status
  end

  private

  def build_post
    @post = Post.new title: '逼塔城街长选举通知', content: '命你为街长', user: @user, board: @board
  end

  def make_post
    build_post
    @post.save!
  end
end
