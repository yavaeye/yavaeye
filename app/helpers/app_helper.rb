helpers do
  # default method is POST instead of html's GET
  # fake PUT and DELETE with _method
  def form action, params={}
    params[:action] = action
    method = params.delete :method
    method ||= params.delete 'method'
    method = (method || 'post').to_s.downcase
    method_magic =
      if method =~ /^(put|delete)$/
        method = 'post'
        "<input type='hidden' name='_method' value='#{method}'></input>"
      end
    params = params.map{|(k, v)| "#{k}=#{v.to_s.inspect}" }.join ' '
    "<form #{params} method='#{method}'>#{csrf}#{method_magic}#{yield}</form>"
  end

  def csrf
    "<input type='hidden' name='authenticity_token' value='#{session[:csrf]}'></input>"
  end

  def meta_csrf
    "<meta name='csrf-param' content='authenticity_token'/><meta name='csrf-token' content='#{session[:csrf]}'/>"
  end
end