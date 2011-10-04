get '/comments/:id' do |id|
  comment = Comment.where(_id: id).first
  if comment.blank?
    status 404
  else
    respond_with :'comment/index', comment
  end
end

post '/comments' do
  post = Post.where(_id: params[:post_id]).first
  comment = Comment.create(params[:comment], user: current_user, post: post)
  if comment.persisted?
    status 200
  else
    status 500
  end
end

put '/comments/:id' do |id|
  comment = Comment.where(_id: id).first
  if comment.blank?
    status 404
  else
    if comment.update_attributes(params[:comment])
      status 200
    else
      status 500
    end
  end
end

delete '/comments/:id' do |id|
  comment = Comment.where(_id: id).first
  if comment.blank?
    status 404
  else
    if comment.delete
      status 200
    else
      status 500
    end
  end
end

