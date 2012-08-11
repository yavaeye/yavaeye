require "open-uri"

helpers do
  include Sprockets::Helpers
  include FormProxy::Helpers

  def js file
    file = "js/#{file}.js"
    %Q|<script src='#{asset_path file}'></script>|
  end

  def css file
    file = "css/#{file}.css"
    %Q|<link rel='stylesheet' href='#{asset_path file}'/>|
  end

  def current_user
    @current_user ||= begin
      User.where(id: session['user_id']).first if session['user_id']
    end
  end

  def authenticate!
    redirect '/' unless current_user
  end

  def gravatar_url gravatar_id
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=32"
  end

  def github_oauth_client
    @github_oauth_client ||= OAuth2::Client.new(settings.github["id"], settings.github["secret"],
                                 :site => "https://github.com",
                                 :authorize_url => "/login/oauth/authorize",
                                 :token_url => "/login/oauth/access_token")
  end

  def google_oauth_client
    @google_oauth_client ||= OAuth2::Client.new(settings.google["id"], settings.google["secret"],
                                 :site => "https://accounts.google.com",
                                 :authorize_url => "/o/oauth2/auth",
                                 :token_url => "/o/oauth2/token")
  end

  def readify(link)
    Readability::Document.new(open(link).read).content
  end

  def markdown(text)
    renderer = HTMLwithCodeRay.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
end
