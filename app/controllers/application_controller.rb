get '/' do
  page = params[:page].to_i
  if page < 1 or page > 100
    page = 1
  end
  @posts = Post.order('created_at DESC').paginate params[:page]
  slim :'posts/index'
end
