get '/comments/:id' do |id|
  comment = Comment.where(_id: id).first
  respond_with :'comment/show', comment
end

get '/comments/new' do
  respond_with :'comment/new', Comment.new
end

post '/comments' do
  post = Post.where(_id: params[:post_id]).first
  comment = Comment.create(params[:comment], user: current_user, post: post)
  if comment.persisted?
      status 200
  else
      respond_with :'comment/new', comment
  end
end

put '/comments/:id' do |id|
  comment = Comment.where(_id! id).first
  if comment.blank?
    status 404
  else
    if comment.update_attributes(params[:comment])
      status 200
    else
      respond_with :'comment/:id/edit', comment
    end
  end
end

delete '/comments/:id' do |id|
  comment = Comment.where(_id! id).first
  if comment.blank?
    status 404
  else
    if comment.delete
      status 200
    else
      respond_with :'comment/:id/edit', comment
    end
  end
end

