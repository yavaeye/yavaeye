helpers do
  def current_user
    @current_user ||= begin
      User.where(_id: session['user_id']).first if session['user_id']
    end
  end

  def authenticate!
    redirect '/' unless current_user
  end
end

