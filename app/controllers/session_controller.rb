# encoding: UTF-8

get '/session/new' do
  slim :'session/new'
end

post '/session/?' do
  openid_remember params[:openid_remember]
  identifier = params[:openid_identifier]
  if url = openid_consumer.redirect_url(identifier, request.host_with_port, "/session/complete")
    redirect url
  else
    flash[:notice] = "与 openid 提供者 '#{identifier}' 联络失败"
    redirect '/'
  end
end

# openid provider redirects here
get '/session/complete' do
  fail_msg, openid, email = openid_consumer.complete(params, request.url)
  4.times{puts}
  p email
  if fail_msg
    flash[:notice] = fail_msg
    redirect '/session/login'
  else
    if @user = User.where(openid: openid).first and @user.nick.present?
      session[:user_id] = @user.id.to_s
      remember_me @user
      flash[:notice] = "登录成功"
      redirect '/'
    else
      session[:user_openid] = openid
      @user ||= User.new
      redirect '/user/new'
    end
  end
end

delete '/session/?' do
  session.delete :user_id
  forget_me
  flash[:notice] = "已注销"
  redirect "/"
end
