helpers do
  def find_post 
    @post = Post.where(token: params[:token], user_id: session[:user_id]).first
    halt 404 unless @post
  end
end
