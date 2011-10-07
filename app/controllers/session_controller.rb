# encoding: UTF-8

post '/session/?' do
  identifier =
    case params[:identifier]
    when 'google'; 'https://www.google.com/accounts/o8/id'
    when 'yahoo'; 'http://me.yahoo.com/'
    else redirect '/'
    end
  if url = openid_consumer.redirect_url(identifier, request.host_with_port, "/session/complete")
    redirect url
  else
    flash[:notice] = "与 OpenID 提供者 '#{identifier}' 联络失败"
    redirect '/'
  end
end

# openid provider redirects here
get '/session/complete' do
  fail_msg, openid, email = openid_consumer.complete(params, request.url)
  if fail_msg
    flash[:notice] = fail_msg
    redirect '/session/login'
  elsif email.blank?
    flash[:notice] = '邮件地址错误...'
    redirect '/session/login'
  else
    if @user = User.where(openid: openid).first
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

delete '/session/?' do
  session.delete :user_id
  forget_me
  flash[:notice] = "已注销"
  redirect "/"
end
