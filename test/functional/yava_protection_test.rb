require_relative "../test_helper"

class YavaProtectionTest < FunctionalTestCase
  def setup
    ::Rack::YavaProtection.enable
    login
    session['admin'] = true
    session['csrf'] = 'random-string'
    @user_params = Factory.build(:user).attributes.keep_if do |k, v|
      %w[nick credentials gravatar_id].include? k
    end
  end

  def teardown
    ::Rack::YavaProtection.disable
  end

  def test_csrf_forbids_post
    count = User.count
    post '/admin/user', {user: @user_params}
    assert_equal count, User.count
  end

  def test_csrf_validates_post
    count = User.count
    post '/admin/user', {user: @user_params, 'authenticity_token' => 'random-string'}
    assert_equal count + 1, User.count
  end

  def test_csrf_ignores_get
    get '/admin/user'
    assert_equal 200, status
  end
end