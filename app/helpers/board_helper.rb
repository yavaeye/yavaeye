helpers do
  def find_board
    @board = Board.find_by_name params[:name]
    halt 404 unless @board
  end
end
