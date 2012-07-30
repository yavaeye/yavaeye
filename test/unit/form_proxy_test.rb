# encoding: UTF-8

require "cgi"
require_relative "../test_helper"

class FormProxyTest < TestCase
  def setup
    @f = FormProxy.new(User.new name: 'hello')
  end

  def test_text_date_number_email
    %w[text date number email].each do |kind|
      out = @f.send kind, :name, 'readonly' => true
      assert_equal '<input type="' + kind + '" id="user_name" name="user[name]" readonly="readonly" value="hello"></input>', out
    end
  end

  def test_hidden
    out = @f.hidden :name, id: 'user_nikulu'
    assert_equal '<input type="hidden" id="user_nikulu" name="user[name]" value="hello"></input>', out
  end

  def test_checkbox
    out = @f.checkbox :name
    assert_equal '<input type="hidden" name="user[name]" value="0"></input><input type="checkbox" checked="checked" id="user_name" name="user[name]" value="1"></input>', out
  end

  def test_radio
    out = @f.radio :name
    assert_equal '<input type="hidden" name="user[name]" value="0"></input><input type="radio" checked="checked" id="user_name" name="user[name]" value="1"></input>', out
  end

  def test_password
    out = @f.password :name
    assert_equal '<input type="password" id="user_name" name="user[name]" value="hello"></input>', out
  end

  def test_textarea
    out = @f.textarea :name
    assert_equal '<textarea id="user_name" name="user[name]">hello</textarea>', out
  end

  def test_select
    out = @f.select :name, {'one' => 1, 'two' => 2}
    assert_equal '<select id="user_name" name="user[name]" value="hello"><option value="1">one</option><option value="2">two</option></select>', out
    out = @f.select :name, [['one', 1], ['two', "hello"]]
    assert_equal '<select id="user_name" name="user[name]" value="hello"><option value="1">one</option><option value="hello" selected="selected">two</option></select>', out
  end

  def test_submit
    out = CGI.unescape_html @f.submit 'hello'
    assert_equal '<input type="submit" class="button" data-disable-with="ʅ(‾◡◝)ʃ ,｡○°" value="hello"></input>', out
  end

  def test_error
    user = User.new
    user.save
    f = FormProxy.new user
    out = f.error :openid
    assert out.start_with? '<span class="error">'
  end

  def test_unicode
    out = CGI.unescape_html(@f.text :name, :value => "尼克")
    assert_equal '<input type="text" id="user_name" name="user[name]" value="尼克"></input>', out
  end
end
