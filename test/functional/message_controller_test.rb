# encoding: UTF-8

require_relative '../test_helper'

class MessageControllerTest < FunctionalTestCase
  def setup
    login
    @message = Message.create! :text => "testing ~", :user => @user
  end

  def test_update
    put "/message/#{@message.id}/read", with_csrf
    @message.reload
    assert_equal true, @message.read
  end

  def test_delete
    delete "/message/#{@message.id}", with_csrf
    assert_nil Message.find_by_id @message.id
  end
end
