get '/boards/:slug' do |slug|
  board = Board.find_by_slug slug
  if params[:token].blank?
    posts = Post.paginate board_id: board._id
  else
    posts = Post.paginate_by_token params[:token], board_id: board._id
  end
  respond_with :index, posts.to_a
end

get '/boards' do
  boards = Board.all
  respond_with :index, boards.to_a
end

get '/boards/new' do
  respond_with :'board/new', Board.new
end

post '/boards' do
  board = Board.create(params[:board], user: current_user)
  if board.persisted?
    status 200
  else
    status 500
  end
end

get '/boards/:slug/edit' do
  board = Board.find_by_slug slug
  respond_with :'board/edit', board
end

put '/boards/:slug' do
  board = Board.find_by_slug slug
  if board
    status 404
  else
    if board.update_attributes(params[:board])
      status 200
    else
      status 500
    end
  end
end

delete '/boards/:slug' do
  board = Board.find_by_slug slug
  if board
    status 404
  else
    if board.delete
      status 200
    else
      status 500
    end
  end
end

