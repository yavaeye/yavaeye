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

  def readify(link)
    Readability::Document.new(open(link).read).content
  end

  def markdown(text)
    @__renderer ||= Redcarpet::Markdown.new(HTMLwithCodeRay.new(filter_html: true), {
      no_intra_emphasis: true,
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_html_blocks: true,
      space_after_headers: true,
      superscript: true
    })

    @__renderer.render(text).html_safe
  end
end
