# encoding: UTF-8

require_relative "../test_helper"

class SessionControllerTest < FunctionalTestCase

  def test_login_with_github
    post '/session/?identifier=github'
    assert last_response.header["Location"].match(/^https:\/\/github.com\//)
  end

  def test_login_with_others
    post '/session/?identifier=other'
    assert last_response.header["Location"].match(/^http:\/\/example.org\//)
  end

end
