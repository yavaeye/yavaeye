get '/posts' do
  if params[:token].blank?
    posts = Post.paginate
  else
    posts = Post.paginate_by_token params[:token]
  end
  respond_with :index, posts.to_a
end

get '/posts/:token' do |token|
  post = Post.find_by_token token
  respond_with :'post/show', post
end

get '/posts/new' do
  respond_with :'post/new', Post.new
end

post '/posts' do
  board = Board.where(_id: params[:board_id]).first
  post = Post.create(params[:post], user: current_user, board: board)
  if post.persisted?
    status 200
  else
    status 500
  end
end

get '/posts/:token/edit' do |token|
  post = Post.find_by_token token
  respond_with :'post/edit', post
end

put '/posts/:token' do |token|
  post = Post.find_by_token(token)
  if post.blank?
    status 404
  else
    if post.update_attributes(params[:post])
      status 200
    else
      status 500
    end
  end
end

delete '/posts/:token' do |token|
  post = Post.find_by_token(token)
  if post.blank?
    status 404
  else
    if post.delete
      status 200
    else
      status 500
    end
  end
end

