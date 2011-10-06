# encoding: UTF-8

get '/' do
  @posts =
    if params[:token].blank?
      Post.paginate
    else
      Post.paginate_by_token params[:token]
    end
  slim :'post/index'
end

get '/posts/new' do
  @post = Post.new
  board = Board.find_by_name params[:board]
  @post.board = board if board and board.active
  slim :'post/new'
end

get '/posts/:token' do |token|
  post = Post.find_by_token token
  respond_with :'post/show', post
end

post '/posts' do
  @post = Post.new params[:post]
  @post.user = current_user
  if @post.save
    flash[:notice] = '发表成功'
    redirect '/'
  else
    slim :'post/new'
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

