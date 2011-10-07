helpers do
  def find_post 
    @post = Post.find_by_token params[:token]
    halt 404 if !@post
  end
end