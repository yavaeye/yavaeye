get '/user/login' do

end

get '/user/logout' do

end

get '/user/profile' do
  respond_with :'user/profile', current_user
end

get '/user/mentions'
  if current_user.blank?
    status 404
  else
    respond_with :'user/mention', current_user.mentions
  end
end

get '/user/inbox' do
  if current_user.blank?
    status 404
  else
    respond_with :'user/inbox', current_user.received_messages
  end
end

get '/user/outbox' do
  if current_user.blank?
    status 404
  else
    respond_with :'user/outbox', current_user.sent_messages
  end
end

