get '/posts' do
  @posts = Post.paginate params[:page]
  slim :'posts/index'
end
