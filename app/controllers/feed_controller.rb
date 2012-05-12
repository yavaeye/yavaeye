get '/feed' do
  content_type 'text/xml'
  @posts = Post.order_by(:created_at.desc).limit(20).to_a
  slim :'feed/index', layout: false
end
