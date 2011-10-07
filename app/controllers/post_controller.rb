# encoding: UTF-8

get '/' do
  @posts =
    if params[:token].blank?
      Post.paginate
    else
      Post.paginate_by_token params[:token]
    end
  @posts = @posts.to_a
  respond_with :'post/index', @posts
end

get '/post/new' do
  authenticate!
  @post = Post.new
  board = Board.find_by_name params[:board]
  @post.board = board if board and board.active
  slim :'post/new'
end

get '/post/:token' do
  find_post
  respond_with :'post/show', @post
end

post '/post' do
  authenticate!
  @post = Post.new params[:post]
  halt 406 if !@post.board.active
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

get '/post/:token/edit' do
  authenticate!
  find_post
  respond_with :'post/edit', @post
end

put '/post/:token' do
  authenticate!
  find_post
  if @post.update_attributes(params[:post])
    respond_to do |f|
      f.html { flash[:notice] = '更新成功'; redirect "/post/#{@post.token}" }
      f.json { @post.to_json }
    end
  else
    respond_with :'post/edit', @post
  end
end

delete '/post/:token' do
  authenticate!
  find_post
  flash[:notice] = @post.destroy ? '删掉了' : '删不掉'
  redirect back
end
