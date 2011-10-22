# encoding: utf-8
get '/boards' do
  @boards = Board.all
  respond_with :'board/index', @boards
end

get '/board/new' do
  authenticate!
  @board = Board.new
  respond_with :'board/new', @board
end

get '/board/:name' do
  params[:order_by] ||= :rank
  @board = Board.where(name: params[:name]).first
  redirect '/' unless @board
  if params[:token].blank?
    @posts = Post.paginate(board_id: @board._id, order_by: params[:order_by])
  else
    @posts = Post.paginate_by_token params[:token], board_id: @board._id, order_by: params[:order_by]
  end
  @posts = @posts.to_a
  @good_boards, @bad_boards = Board.for current_user
  respond_with :'post/index', @posts
end

post '/board' do
  authenticate!
  @board = Board.new params[:board]
  @board.user = current_user
  @board.save
  if @board.persisted?
    respond_to do |f|
      f.html { flash[:notice] = '提交申请,请静候领导审批.'; redirect '/' }
      f.json { @board.to_json }
    end
  else
    respond_with :'post/index', @board
  end
end

get '/board/:name/edit' do
  authenticate!
  find_board
  respond_with :'board/edit', @board
end

put '/board/:name' do
  authenticate!
  find_board
  if @board.update_attributes(params[:board])
    respond_to do |f|
      f.html { flash[:notice] = '更新成功'; redirect "/board/#{@board.name}" }
      f.json { @board.to_json }
    end
  else
    respond_with :'board/edit', @board
  end
end

delete '/board/:name' do
  authenticate!
  find_board
  flash[:notice] = @board.destroy ? '删掉了' : '删不掉'
  redirect back
end
