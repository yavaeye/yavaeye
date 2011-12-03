# encoding: UTF-8

put '/message/:id/read' do |id|
  message = current_user.messages.find_by_id id
  if message
    message.update_attribute :read, true
    status 200
  else
    status 404
  end
end

delete '/message/:id' do |id|
  current_user.messages.find_by_id(id).try :destroy
  status 200
end
