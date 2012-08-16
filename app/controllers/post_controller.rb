# encoding: UTF-8

before 'post/:id/?*' do |id, path|
  @post = Post.where(id).first
  # TODO halt 404
end

get '/posts' do
  @posts = Post.paginate params[:page]
  slim :'posts/index'
end

get '/post/new' do
  @post = Post.new
  slim :'post/new'
end

get '/post/:id' do |id|
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

get '/post/:id/edit' do
  slim :'post/edit'
end

put '/post/:id' do |id|
  if @post.update_attributes(params[:post])
    respond_to do |f|
      f.html { flash[:notice] = '更新成功'; redirect "/post/#{@post.id}" }
      f.json { @post.to_json }
    end
  else
    respond_with :'post/edit', @post
  end
end

delete '/post/:id' do |id|
  flash[:notice] = @post.destroy ? '删掉了' : '删不掉'
  redirect back
end
