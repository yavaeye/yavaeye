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
      User.where(_id: session['user_id']).first if session['user_id']
    end
  end

  def authenticate!
    redirect '/' unless current_user
  end

  def gravatar_url gravatar_id
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=32"
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
