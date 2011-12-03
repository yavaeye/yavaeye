# encoding: UTF-8

post '/session/?' do
  identifier =
    case params[:identifier]
    when 'google'
      identifier = 'https://www.google.com/accounts/o8/id'
      if url = openid_consumer.redirect_url(identifier, request.host_with_port, "/openid/authorize")
        redirect url
      else
        flash[:notice] = "与 OpenID 提供者 '#{identifier}' 联络失败"
        redirect '/'
      end
    when 'github'
      identifier = 'https://github.com/'
      redirect github_client.auth_code.authorize_url
    else
      flash[:notice] = "缺少登录提供商"
      redirect '/'
    end
end

# openid provider redirects here
get '/openid/authorize' do
  fail_msg, openid, email = openid_consumer.complete(params, request.url)
  if fail_msg
    flash[:notice] = fail_msg
    redirect '/session/login'
  elsif email.blank?
    flash[:notice] = '邮件地址错误...'
    redirect '/session/login'
  else
    if @user = User.where(email: email).first
      session[:user_id] = @user.id.to_s
      remember_me @user
      flash[:notice] = "登录成功"
      redirect '/'
    else
      session[:user_openid] = openid
      session[:user_email] = email
      redirect '/user-new'
    end
  end
end

get '/oauth/authorize' do
  code = params['code']
  if code.blank?
    flash[:notice] = "认证错误..."
    redrect '/session/login'
  else
    token = github_client.auth_code.get_token(code)
    request = token.get("https://api.github.com/user", params: {access_token: token})
    body = JSON.parse(request.body)
    if @user = User.where(github_token: token.token).first
      session[:user_id] = @user.id.to_s
      remember_me @user
      flash[:notice] = "登录成功"
      redirect '/'
    else
      session[:user_github_token] = token.token
      session[:user_nick] = body["name"]
      session[:user_email] = body["email"]
      redirect '/user-new'
    end
  end
end

delete '/session/?' do
  session.delete :user_id
  forget_me
  flash[:notice] = "已注销"
  redirect "/"
end
