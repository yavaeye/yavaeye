helpers do
  def openid_consumer
    @openid_consumer ||= OpenID::YavaConsumer.new session
  end

  def remember_me user
    # NOTE cookies[] is string key only
    if request.cookies['openid_remember'] == 'on'
      response.set_cookie 'remember_me',
        path: '/',
        value: Secret.encrypt(user.id.to_s),
        expires: Time.now.next_month,
        httponly: true
    end
  end

  def forget_me
    # XXX delete_cookie doesn't work
    response.set_cookie 'remember_me',
      path: '/',
      value: "",
      expire_after: 60,
      httponly: true
  end

  # call-seq:
  #
  #   == form @post, action: '/a/b', method: 'delete' do |f|
  #     == f.text 'nick'
  #
  #   == form action: '/a/b', method: 'get' do
  #     input type='text' name='n' value='xx'
  #
  # Default method is POST, also adds csrf token, simulates PUT and DELETE with _method.
  def form obj, params=nil
    if params.nil?
      params = obj
      body = yield
    else
      body = yield FormProxy.new obj
    end
    params = params.symbolize_keys
    method = (params.delete(:method) or 'post')
    params[:'accept-charset'] ||= 'UTF-8'
    if method =~ /^(put|delete)$/
      method_override = "<input type='hidden' name='_method' value='#{method}'></input>"
      method = 'post'
    end
    params = params.to_attrs
    "<form method='#{method}' #{params}>#{csrf}#{method_override}#{body}</form>"
  end

  def csrf
    "<input type='hidden' name='authenticity_token' value='#{session[:csrf]}'></input>"
  end

  def meta_csrf
    "<meta name='csrf-param' content='authenticity_token'/><meta name='csrf-token' content='#{session[:csrf]}'/>"
  end
end