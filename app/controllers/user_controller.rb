# encoding: UTF-8

post '/user' do
  @user = User.new\
    gravatar_id: session[:user_gravatar_id],
    nick: params[:user][:nick],
    credentials: {
      github_oauth_token: session[:user_github_oauth_token],
      google_openid: session[:user_google_openid]
    }
  if @user.save
    session.delete_if { |k, v| k.to_s.start_with? 'user' }
    session[:user_id] = @user.id.to_s
    flash[:notice] = '用户创建成功'
    { redirect: '/' }.to_json
  else
    { error: { user: @user.errors } }.to_json
  end
end

get '/user/:nick' do
  redirect '/' if current_user.blank?
  respond_with :'/user/index'
end
