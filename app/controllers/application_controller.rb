get '/' do
  @posts = []
  slim :'posts/index'
end
