helpers do
  def find_board
    @board = Board.where(name: params[:name], user_id: session[:user_id]).first
    halt 404 unless @board
  end
end
