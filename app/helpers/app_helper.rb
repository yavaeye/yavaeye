helpers do
  # call-seq:
  #
  #   == form @post, action: '/a/b', method: 'delete' do |f|
  #     == f.text 'nick'
  #
  #   == form action: '/a/b', method: 'get' do
  #     input type='text' name='n' value='xx'
  #
  # Default method is POST, also adds csrf token and simulate PUT and DELETE with _method.
  def form obj, params=nil
    if params.nil?
      params = obj
      body = yield
    else
      body = yield FormProxy.new obj
    end
    params = params.symbolize_keys
    action = params.delete :action # no escape
    method = (params.delete(:method) or 'post')
    if method =~ /^(put|delete)$/
      method_override = "<input type='hidden' name='_method' value='#{method}'></input>"
      method = 'post'
    end
    params = params.to_attrs
    "<form action='#{action}' method='#{method}' #{params}>#{csrf}#{method_override}#{body}</form>"
  end

  def csrf
    "<input type='hidden' name='authenticity_token' value='#{session[:csrf]}'></input>"
  end

  def meta_csrf
    "<meta name='csrf-param' content='authenticity_token'/><meta name='csrf-token' content='#{session[:csrf]}'/>"
  end
end