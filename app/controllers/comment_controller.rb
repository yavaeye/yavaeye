##encoding: utf-8
get '/comment/:id' do |id|
  comment = Comment.where(_id: id).first
  respond_with :'comment/show', comment
end

get '/comment/new' do
  respond_with :'comment/new', Comment.new
end

post '/comment' do
  authenticate!
  @post = Post.where(_id: params[:post_id]).first
  @comment = Comment.new(params[:comment],user: current_user, post: @post)
  @comment.save
  if @comment.persisted?
    respond_to do |f|
      f.html { flash[:notice] = '吐槽成功'; redirect "/post/#{@comment.post.token}" }
      f.json { @comment.to_json }
    end
  else
    respond_with :"/post/#{@comment.post.token}", @comment.errors
  end
end

put '/comment/:id' do |id|
  authenticate!
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

delete '/comment/:id' do |id|
  authenticate!
  @comment = Comment.where(_id: id, user_id: session[:user_id]).first
  flash[:notice] = @comment.destroy ? '删掉了' : '删不掉'
  redirect "/post/#{@comment.post.token}"
end

