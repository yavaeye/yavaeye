helpers do
  def current_user
    User.where(_id: session[:user_id]).first
  end
end

