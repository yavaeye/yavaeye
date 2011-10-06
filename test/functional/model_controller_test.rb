require_relative "../test_helper"

class ModelControllerTest < FunctionalTestCase
  def setup
    @user = Factory(:user)
    @opts = {'rack.session' => {'admin' => true, 'csrf' => 'random-string'}}
    @user_params = {
      openid: "http://google.com/o8/id/exBmi19p",
      nick: "yavaeye2",
      email: "yavaeye2@gmail.com"
    }
  end

  def test_index
    access_protected :get, '/admin/user'
  end

  def test_edit
    access_protected :get, "/admin/user/#{@user.id}/edit"
  end
  
  def test_csrf_create
    count = User.count
    post '/admin/user', {user: @user_params}, @opts
    assert_equal count, User.count
  end
  
  def test_create 
    count = User.count
    post '/admin/user', {'authenticity_token' => 'random-string', user: @user_params}, @opts
    p body
    assert_equal count + 1, User.count
  end

  private

  def access_protected verb, url
    send verb, url, {}, @opts
    assert_equal 200, status
    send verb, url
    assert_equal 302, status
  end
end