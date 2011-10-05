put '/messages/:id/edit' do
  message = Message.where(_id: id).first
  if message
    status 404
  else
    if message.update_attribute(params[:message])
      status 200
    else
      status 500
    end
  end
end

delete '/messages/:id' do
  message = Message.where(_id: id).first
  if message
    status 404
  else
    if message.delete
      status 200
    else
      status 500
    end
  end
end

