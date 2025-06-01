require_relative "piece"

class Board
  def initialize(board = Array.new(8) { Array.new(8) { "." } })
    @board = board
  end

  def setup_board
    @board = Array.new(8) { Array.new(8) { "." } }
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
      @board[6][i] = Pawn.new(6, i, "white", @board)
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

  def get_king_squares(color)
    king_pos = king_position(color)
    king_squares = @board[king_pos[0]][king_pos[1]].possible_moves
    king_squares.push(king_pos)
    @board.each do |row|
      row.each do |box|
        king_squares -= box.protect_moves if box != "." && box.color != color
      end
    end
    king_squares
  end

  def get_king_move_squares(color)
    king_pos = king_position(color)
    king_squares = @board[king_pos[0]][king_pos[1]].possible_moves
    @board.each do |row|
      row.each do |box|
        king_squares -= box.protect_moves if box != "." && box.color != color
      end
    end
    king_squares
  end

  def checkmate?(color)
    return false unless check?(color)

    @board.each do |row|
      row.each do |box|
        next if box == "." || box.color != color

        if box.is_a?(King)
          get_king_squares(color).each do |move|
            return false if block_check_king?(move[0], move[1], color)
          end
        else
          box.possible_moves.each do |move|
            return false if block_check?(move[0], move[1], color)
          end
        end
      end
    end
    true
  end

  def stalemate?(color)
    @board.each do |row|
      row.each do |box|
        next if (box != ".") || box.is_a?(King)
        return false if (box != ".") && box.color == color && box.possible_moves.length >= 1
      end
    end
    get_king_move_squares(color).empty?
  end

  def check?(color)
    king_pos = king_position(color)
    @board.each do |row|
      row.each do |box|
        return true if (box != ".") && box.protect_moves.include?(king_pos) && box.color != color
      end
    end
    false
  end

  def get_checkers(color)
    king_pos = king_position(color)
    arr = []
    @board.each do |row|
      row.each do |box|
        arr.push(box) if (box != ".") && box.protect_moves.include?(king_pos) && box.color != color
      end
    end
    arr
  end

  def piece_block(row, column)
    box = @board[row][column]
    color = box.color
    block_moves = []
    if box.is_a?(King)
      get_king_move_squares(color).each do |move|
        block_moves.push(move) if block_check_king?(move[0], move[1], color)
      end
    else
      box.possible_moves.each do |move|
        block_moves.push(move) if block_check?(move[0], move[1], color)
      end
    end
    block_moves
  end

  def block_check_king?(row, column, color)
    can_block = true
    checkers = get_checkers(color)
    king_pos = king_position(color)
    temp_king = @board[king_pos[0]][king_pos[1]]
    temp = @board[row][column]
    @board[king_pos[0]][king_pos[1]] = "."
    @board[row][column] = King.new(row, column, color, @board)
    checkers.each do |checker|
      if checker.possible_moves.include?([row, column])
        can_block = false
        break
      end
    end
    @board[king_pos[0]][king_pos[1]] = temp_king
    @board[row][column] = temp
    can_block
  end

  def block_check?(row, column, color)
    can_block = true
    checkers = get_checkers(color)
    king_pos = king_position(color)
    temp = @board[row][column]
    @board[row][column] = Pawn.new(row, column, color, @board)
    checkers.each do |checker|
      if checker.possible_moves.include?(king_pos)
        can_block = false
        break
      end
    end
    @board[row][column] = temp
    can_block
  end

  def no_check_moves(row, column, color)
    arr = []
    box = @board[row][column]
    if box.is_a?(King)
      get_king_move_squares(color).each do |move|
        arr.push(move) unless cause_check_king?([row, column], move, color)
      end
    else
      box.possible_moves.each do |move|
        arr.push(move) unless cause_check?([row, column], move, color)
      end
    end
    arr
  end

  def cause_check?(old_coords, new_coords, color)
    check = true
    temp_piece = @board[old_coords[0]][old_coords[1]]
    temp = @board[new_coords[0]][new_coords[1]]
    @board[old_coords[0]][old_coords[1]] = "."
    @board[new_coords[0]][new_coords[1]] = Pawn.new(new_coords[0], new_coords[1], color, @board)
    check = check?(color)
    @board[old_coords[0]][old_coords[1]] = temp_piece
    @board[new_coords[0]][new_coords[1]] = temp
    check
  end

  def cause_check_king?(old_coords, new_coords, color)
    check = true
    temp_piece = @board[old_coords[0]][old_coords[1]]
    temp = @board[new_coords[0]][new_coords[1]]
    @board[old_coords[0]][old_coords[1]] = "."
    @board[new_coords[0]][new_coords[1]] = King.new(new_coords[0], new_coords[1], color, @board)
    check = check?(color)
    @board[old_coords[0]][old_coords[1]] = temp_piece
    @board[new_coords[0]][new_coords[1]] = temp
    check
  end

  def king_position(color)
    @board.each_with_index do |row, i|
      row.each_with_index do |box, j|
        return [i, j] if box.is_a?(King) && box.color == color
      end
    end
    nil
  end

  def check_promotion
    [0, 7].each do |i|
      @board[i].each_with_index do |box, index|
        return [i, index] if box.is_a?(Pawn)
      end
    end
    nil
  end

  def box_open?(row, column)
    @board[row][column] == "."
  end

  def get_color(row, column)
    @board[row][column].color
  end

  def get_moves(row, column)
    return if box_open?(row, column)

    @board[row][column].possible_moves
  end

  def move(row, column, new_row, new_column)
    piece = @board[row][column]
    piece.move(new_row, new_column)
  end

  def promote_pawn(row, column, type)
    @board[row][column].promote(type)
  end
end
