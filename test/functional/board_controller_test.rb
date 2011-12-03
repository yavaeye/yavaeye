# encoding: UTF-8

require_relative "../test_helper"

class BoardControllerTest < FunctionalTestCase
  def setup
    login

    @other_user = Factory.build(:user)
    @other_logged_in_session = {'rack.session' => {'user_id' => @other_user.id.to_s}}

    @board = Factory(:board)
  end

  def test_new
    get '/board/new'
    assert_equal 200, status
  end

  def test_new_forbidden
    session.clear
    get '/board/new'
    assert_equal 302, status
  end

  def test_edit
    get "/board/#{@board.name}/edit"
    assert_equal 200, status
  end

   def test_edit_forbidden
    get "/board/#{@board.name}/edit", {}, @other_logged_in_session
    assert_equal 302, status
  end

end
