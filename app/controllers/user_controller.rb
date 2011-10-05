get '/user-new' do
  slim :'user/new'
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
