# encoding: UTF-8

post '/user' do
  @user = User.new
  @user.gravatar_id = session.delete :user_gravatar_id
  if (token = session.delete :user_github_oauth_token)
    @user.credentials[:github_oauth_token] = token
  end
  if (openid = session.delete :user_google_openid)
    @user.credentials[:google_openid] = openid
  end
  @user.nick = params[:user][:nick]
  if @user.save
    session[:user_id] = @user.id.to_s
    flash[:notice] = '用户创建成功'
    redirect '/'
  else
    slim :'user/new'
  end
end

before '/user/*' do
  redirect '/' if current_user.blank?
end

get '/user/:nick' do
  respond_with :'/user/index'
end
