get '/boards/:name' do |name|
  board = Board.find_by_name name
  if params[:token].blank?
    posts = Post.paginate board_id: board._id
  else
    posts = Post.paginate_by_token params[:token], board_id: board._id
  end
  respond_with :index, posts: posts.to_a
end

get '/boards' do
  boards = Board.all
  respond_with :'board/index', boards: boards.to_a
end

get '/boards/new' do
  respond_with :'board/new', board: Board.new
end

post '/boards' do
  board = Board.create(params[:board], user: current_user)
  if board.persisted?
    status 200
  else
    status 500
  end
end

get '/boards/:name/edit' do
  board = Board.find_by_name name
  respond_with :'board/edit', board
end

put '/boards/:name' do
  board = Board.find_by_name name
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

delete '/boards/:name' do
  board = Board.find_by_name name
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

