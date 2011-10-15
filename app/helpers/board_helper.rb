helpers do
  def find_board
    @board = Board.find_by_name(params[:name]).where(user_id: session[:user_id]).first
    halt 404 unless @board
  end
end
