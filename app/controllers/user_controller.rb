# encoding: UTF-8

get '/user-new' do
  if session[:user_openid].blank? or session[:user_email].blank? or current_user
    redirect '/'
  end
  @user = User.new
  slim :'user/new'
end

post '/user' do
  if session[:user_openid].blank? or session[:user_email].blank? or params[:user].blank?
    redirect '/'
  end
  @user = User.new
  @user.openid = session.delete :user_openid
  @user.email = session.delete :user_email
  @user.nick = params[:user][:nick]
  if @user.save
    flash[:notice] = '用户创建成功'
    redirect '/'
  else
    slim :'user/new'
  end
end

get '/user/*' do
  pass unless current_user
  redirect to '/session/new'
end

get '/user/profile' do
  respond_with :'user/profile', current_user
end

get '/user/achievements' do
  respond_with :'user/achievement', current_user
end

get '/user/mentions' do
  respond_with :'user/mention', current_user.mentions
end

get '/user/inbox' do
  respond_with :'user/inbox', current_user.received_messages
end

get '/user/outbox' do
  respond_with :'user/outbox', current_user.sent_messages
end

get '/user/posts' do
  respond_with :'user/posts', current_user.posts
end

get '/user/comments' do
  respond_with :'user/comments', current_user.comments
end

get '/user/boards' do
  respond_with :'user/boards', current_user.boards
end
