# encoding: UTF-8

require_relative "../test_helper"

class BoardControllerTest < FunctionalTestCase
  def setup
    @user = Factory(:user)
    @logged_in_session = {'rack.session' => {'user_id' => @user.id.to_s, 'csrf' => 'random-string'}}
    
    @other_user = User.new \
      nick: @user.nick + '-other',
      openid: @user.openid + '-other',
      email: @user.email + '-other'
    @other_logged_in_session = {'rack.session' => {'user_id' => @other_user.id.to_s, 'csrf' => 'random-string'}}
    
    @board = Factory(:board)
  end
  
  def test_new
    get '/board/new', {}, @logged_in_session
    assert_equal 200, status
  end
  
  def test_new_forbidden
    get '/board/new'
    assert_equal 302, status
  end
  
  def test_edit 
    get "/board/#{@board.name}/edit", {}, @logged_in_session
    assert_equal 200, status
  end
  
   def test_edit_forbidden
    get "/board/#{@board.name}/edit", {}, @other_logged_in_session
    assert_equal 302, status
  end
  
end
