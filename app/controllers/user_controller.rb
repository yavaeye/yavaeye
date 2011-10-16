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

get '/user/profile' do
  respond_with :'user/index'
end

get '/user/achievements' do
  respond_with :'user/achievement', achievements: current_user.achievements
end

get '/user/mentions' do
  respond_with :'user/mention', mentions: current_user.mentions
end

get '/user/inbox' do
  respond_with :'user/inbox', received_messages: current_user.received_messages
end

get '/user/outbox' do
  respond_with :'user/outbox', sent_messages: current_user.sent_messages
end

get '/user/boards' do
  respond_with :'user/boards', subscribes: current_user.subscribes, unsubscribes: current_user.unsubscribes
end

get '/user/posts' do
  respond_with :'user/posts', posts: current_user.posts
end

get '/user/comments' do
  respond_with :'user/comments', comments: current_user.comments
end

