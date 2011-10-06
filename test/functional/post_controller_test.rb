require_relative "../test_helper"

class PostControllerTest < FunctionalTestCase
  def test_index
    get '/'
    assert_equal 200, status
  end

  def test_new
    get '/posts/new'
    assert_equal 200, status
  end
end
