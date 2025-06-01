require_relative "piece"

class Board
  def initialize(board = Array.new(8) { Array.new(8) { "." } })
    @board = board
  end

  def setup_board
    setup_black
    setup_white
    setup_pawns
  end

  def setup_black
    @board[0][0] = Rook.new(0, 0, "black", @board)
    @board[0][1] = Knight.new(0, 1, "black", @board)
    @board[0][2] = Bishop.new(0, 2, "black", @board)
    @board[0][7] = Rook.new(0, 7, "black", @board)
    @board[0][6] = Knight.new(0, 6, "black", @board)
    @board[0][5] = Bishop.new(0, 5, "black", @board)
    @board[0][4] = King.new(0, 4, "black", @board)
    @board[0][3] = Queen.new(0, 3, "black", @board)
  end

  def setup_white
    @board[7][0] = Rook.new(7, 0, "white", @board)
    @board[7][1] = Knight.new(7, 1, "white", @board)
    @board[7][2] = Bishop.new(7, 2, "white", @board)
    @board[7][7] = Rook.new(7, 7, "white", @board)
    @board[7][6] = Knight.new(7, 6, "white", @board)
    @board[7][5] = Bishop.new(7, 5, "white", @board)
    @board[7][4] = King.new(7, 4, "white", @board)
    @board[7][3] = Queen.new(7, 3, "white", @board)
  end

  def setup_pawns
    8.times do |i|
      @board[1][i] = Pawn.new(1, i, "black", @board)
      @board[6][i] = Pawn.new(1, i, "white", @board)
    end
  end

  def print_board
    print "  "
    8.times do |i|
      print "#{i} "
    end
    puts
    @board.each_with_index do |row, index|
      print "#{index} "
      row.each do |box|
        print "#{box} "
      end
      puts
    end
  end
end
