require_relative "../test_helper"

class FormProxyTest < TestCase
  def setup
    @f = FormProxy.new(User.new nick: 'hello')
  end

  def test_text
    out = @f.text :nick, 'readonly' => true
    assert_equal '<input type="text" id="user_nick" name="user[nick]" readonly="readonly" value="hello"></input>', out
  end

  def test_hidden
    out = @f.hidden :nick, id: 'user_nikulu'
    assert_equal '<input type="hidden" id="user_nikulu" name="user[nick]" value="hello"></input>', out
  end

  def test_checkbox
    out = @f.checkbox :nick
    assert_equal "<input type=\"hidden\" name=\"user[nick]\" value=\"0\"></input><input type=\"checkbox\" checked=\"checked\" id=\"user_nick\" name=\"user[nick]\" value=\"1\"></input>", out
  end

  def test_radio
    out = @f.radio :nick
    assert_equal "<input type=\"hidden\" name=\"user[nick]\" value=\"0\"></input><input type=\"radio\" checked=\"checked\" id=\"user_nick\" name=\"user[nick]\" value=\"1\"></input>", out
  end

  def test_password
    out = @f.password :nick
    assert_equal '<input type="password" id="user_nick" name="user[nick]" value="hello"></input>', out
  end

  def test_textarea
    out = @f.textarea :nick
    assert_equal '<textarea id="user_nick" name="user[nick]">hello</textarea>', out
  end

  def test_select
    out = @f.select :nick, {'one' => 1, 'two' => 2}
    assert_equal '<select id="user_nick" name="user[nick]" value="hello"><option value="1">one</option><option value="2">two</option></select>', out
    out = @f.select :nick, [['one', 1], ['two', "hello"]]
    assert_equal '<select id="user_nick" name="user[nick]" value="hello"><option value="1">one</option><option value="hello" selected="selected">two</option></select>', out
  end

  def test_submit 
    out = @f.submit 'hello'
    assert_equal "<input type=\"submit\" class=\"button\" value=\"hello\"></input>", out
  end

  def test_error 
    user = User.new
    user.save
    f = FormProxy.new user
    out = f.error :openid
    assert_equal "<span class=\"error\">can't be blank</span>", out
  end
end