helpers do
  def current_user
    @current_user ||= begin
      User.where(_id: session['user_id']).first if session['user_id']
    end
  end

  def gravatar_url gravatar_id
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=32"
  end

  def authenticate!
    redirect '/' unless current_user
  end

  def github_client
    @github_client ||= OAuth2::Client.new(settings.github["id"], settings.github["secret"],
                                 :site => "https://github.com",
                                 :authorize_url => "/login/oauth/authorize",
                                 :token_url => "/login/oauth/access_token")
  end
end

