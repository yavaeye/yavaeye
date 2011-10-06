# encoding: UTF-8

get '/' do
  @posts =
    if params[:token].blank?
      Post.paginate
    else
      Post.paginate_by_token params[:token]
    end
  respond_with :'post/index', @posts.to_a
end

get '/posts/new' do
  @post = Post.new
  board = Board.find_by_name params[:board]
  @post.board = board if board and board.active
  slim :'post/new'
end

get '/posts/:token' do |token|
  @post = Post.find_by_token token
  respond_with :'post/show', @post
end

post '/posts' do
  @post = Post.new params[:post]
  @post.user = current_user
  if @post.save
    respond_to do |f|
      f.html { flash[:notice] = '发表成功'; redirect '/' }
      f.json { @post.to_json }
    end
  else
    respond_with :'post/new', errors: @post.errors
  end
end

get '/posts/:token/edit' do |token|
  @post = Post.find_by_token token
  respond_with :'post/edit', @post
end

put '/posts/:token' do |token|
  if @post = Post.find_by_token(token)
    if @post.update_attributes(params[:post])
      respond_to do |f|
        f.html { flash[:notice] = '更新成功'; redirect "/posts/#{@post.token}" }
        f.json { @post.to_json }
      end
    else
      respond_with :'post/edit', @post
    end
  else
    status 404
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

