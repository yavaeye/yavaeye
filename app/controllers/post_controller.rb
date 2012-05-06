# encoding: UTF-8

before 'post/:token/?*' do |token, path|
  @post = Post.find_by_token(token)
end

get '/posts' do
  @posts = Post.paginate params[:page]
  slim :'posts/index'
end

get '/post/new' do
  @post = Post.new
  slim :'post/new'
end

get '/post/:token' do |token|
  slim :'post/show'
end

post '/post' do
  @post = Post.new params[:post]
  @post.author = current_user
  if @post.save
    respond_to do |f|
      f.html { flash[:notice] = '发表成功'; redirect '/' }
      f.json { @post.to_json }
    end
  else
    respond_with :'/post/new', @post
  end
end

get '/post/:token/edit' do |token|
  slim :'post/edit'
end

put '/post/:token' do |token|
  if @post.update_attributes(params[:post])
    respond_to do |f|
      f.html { flash[:notice] = '更新成功'; redirect "/post/#{@post.token}" }
      f.json { @post.to_json }
    end
  else
    respond_with :'post/edit', @post
  end
end

delete '/post/:token' do |token|
  flash[:notice] = @post.destroy ? '删掉了' : '删不掉'
  redirect back
end
