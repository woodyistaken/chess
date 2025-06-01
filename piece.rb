module Moves
  def pawn_moves
    arr = []
    if box_open?(@row + @multiplier, @column)
      arr.push([@row + @multiplier, @column])
      arr.push([@row + (2 * @multiplier), @column]) if box_open?(@row + (2 * @multiplier), @column) && @moved == false
    end
    arr
  end

  def pawn_eat_moves
    arr = []
    [-1, 1].each do |i|
      arr.push([@row + @multiplier, @column + i]) if (@row + @multiplier).between?(0, 7) &&
                                                     (@column + i).between?(0, 7) &&
                                                     !box_open?(@row + @multiplier, @column + i) &&
                                                     get_piece(@row + @multiplier, @column + i).color != @color
    end
    arr
  end

  def protect_pawn_eat_moves
    arr = []
    [-1, 1].each do |i|
      arr.push([@row + @multiplier, @column + i]) if (@row + @multiplier).between?(0, 7) &&
                                                     (@column + i).between?(0, 7) &&
                                                     !box_open?(@row + @multiplier, @column + i)
    end
    arr
  end

  def en_passent_moves
    en_passent_row = @color == "black" ? 4 : 3
    return [] unless @row == en_passent_row

    arr = []
    [-1, 1].each do |i|
      next unless !box_open?(@row, @column + i) &&
                  get_piece(@row, @column + i).is_a?(Pawn) &&
                  get_piece(@row, @column + i).double_moved == true &&
                  get_piece(@row, @column + i).color != @color

      arr.push([@row + @multiplier, @column + i]) if box_open?(@row + @multiplier, @column + i)
    end
    arr
  end

  def row_moves
    arr = []
    (1..7).each do |i|
      break if @row + i > 7

      unless box_open?(@row + i, @column)
        arr.push([@row + i, @column]) if get_piece(@row + i, @column).color != @color
        break
      end

      arr.push([@row + i, @column])
    end
    (1..7).each do |i|
      break if @row - i < 0

      unless box_open?(@row - i, @column)
        arr.push([@row - i, @column]) if get_piece(@row - i, @column).color != @color
        break
      end
      arr.push([@row - i, @column])
    end
    arr
  end

  def protect_row_moves
    arr = []
    (1..7).each do |i|
      break if @row + i > 7

      unless box_open?(@row + i, @column) || get_piece(@row + i, @column).is_a?(King)
        arr.push([@row + i, @column])
        break
      end

      arr.push([@row + i, @column])
    end
    (1..7).each do |i|
      break if @row - i < 0

      unless box_open?(@row - i, @column) || get_piece(@row - i, @column).is_a?(King)
        arr.push([@row - i, @column])
        break
      end
      arr.push([@row - i, @column])
    end
    arr
  end

  def column_moves
    arr = []
    (1..7).each do |i|
      break if @column + i > 7

      unless box_open?(@row, @column + i)
        arr.push([@row, @column + i]) if get_piece(@row, @column + i).color != @color
        break
      end

      arr.push([@row, @column + i])
    end
    (1..7).each do |i|
      break if @column - i < 0

      unless box_open?(@row, @column - i)
        arr.push([@row, @column - i]) if get_piece(@row, @column - i).color != @color
        break
      end
      arr.push([@row, @column - i])
    end
    arr
  end

  def protect_column_moves
    arr = []
    (1..7).each do |i|
      break if @column + i > 7

      unless box_open?(@row, @column + i) || get_piece(@row, @column + i).is_a?(King)
        arr.push([@row, @column + i])
        break
      end

      arr.push([@row, @column + i])
    end
    (1..7).each do |i|
      break if @column - i < 0

      unless box_open?(@row, @column - i) || get_piece(@row, @column - i).is_a?(King)
        arr.push([@row, @column - i])
        break
      end
      arr.push([@row, @column - i])
    end
    arr
  end

  def knight_moves
    moves_arr = []
    [-2, 2].each do |i|
      [-1, 1].each do |j|
        moves_arr.push([@row + i, @column + j]) if (@column + j).between?(0, 7) &&
                                                   (@row + i).between?(0, 7) &&
                                                   (box_open?(@row + i, @column + j) ||
                                                    get_piece(@row + i, @column + j).color != @color)
        moves_arr.push([@row + j, @column + i]) if (@column + i).between?(0, 7) &&
                                                   (@row + j).between?(0, 7) &&
                                                   (box_open?(@row + j, @column + i) ||
                                                    get_piece(@row + j, @column + i).color != @color)
      end
    end
    moves_arr
  end

  def protect_knight_moves
    moves_arr = []
    [-2, 2].each do |i|
      [-1, 1].each do |j|
        moves_arr.push([@row + i, @column + j]) if (@column + j).between?(0, 7) &&
                                                   (@row + i).between?(0, 7)
        moves_arr.push([@row + j, @column + i]) if (@column + i).between?(0, 7) &&
                                                   (@row + j).between?(0, 7)
      end
    end
    moves_arr
  end

  def left_diagonal_moves
    arr = []
    (1..7).each do |i|
      break if @row + i > 7 || @column + i > 7

      unless box_open?(@row + i, @column + i)
        arr.push([@row + i, @column + i]) if get_piece(@row + i, @column + i).color != @color
        break
      end

      arr.push([@row + i, @column + i])
    end
    (1..7).each do |i|
      break if @row - i < 0 || @column - i < 0

      unless box_open?(@row - i, @column - i)
        arr.push([@row - i, @column - i]) if get_piece(@row - i, @column - i).color != @color
        break
      end
      arr.push([@row - i, @column - i])
    end
    arr
  end

  def protect_left_diagonal_moves
    arr = []
    (1..7).each do |i|
      break if @row + i > 7 || @column + i > 7

      unless box_open?(@row + i, @column + i) || get_piece(@row + i, @column + i).is_a?(King)
        arr.push([@row + i, @column + i])
        break
      end

      arr.push([@row + i, @column + i])
    end
    (1..7).each do |i|
      break if @row - i < 0 || @column - i < 0

      unless box_open?(@row - i, @column - i) || get_piece(@row - i, @column - i).is_a?(King)
        arr.push([@row - i, @column - i])
        break
      end
      arr.push([@row - i, @column - i])
    end
    arr
  end

  def right_diagonal_moves
    arr = []
    (1..7).each do |i|
      break if @column + i > 7 || @row - i < 0

      unless box_open?(@row - i, @column + i)
        arr.push([@row - i, @column + i]) if get_piece(@row - i, @column + i).color != @color
        break
      end
      arr.push([@row - i, @column + i])
    end
    (1..7).each do |i|
      break if @column - i < 0 || @row + i > 7

      unless box_open?(@row + i, @column - i)
        arr.push([@row + i, @column - i]) if get_piece(@row + i, @column - i).color != @color
        break
      end

      arr.push([@row + i, @column - i])
    end
    arr
  end

  def protect_right_diagonal_moves
    arr = []
    (1..7).each do |i|
      break if @column + i > 7 || @row - i < 0

      unless box_open?(@row - i, @column + i) || get_piece(@row - i, @column + i).is_a?(King)
        arr.push([@row - i, @column + i])
        break
      end
      arr.push([@row - i, @column + i])
    end
    (1..7).each do |i|
      break if @column - i < 0 || @row + i > 7

      unless box_open?(@row + i, @column - i) || get_piece(@row + i, @column - i).is_a?(King)
        arr.push([@row + i, @column - i])
        break
      end

      arr.push([@row + i, @column - i])
    end
    arr
  end

  def king_moves
    moves_arr = []
    [-1, 0, 1].each do |i|
      [-1, 0, 1].each do |j|
        next if j == 0 && i == 0

        moves_arr.push([@row + i, @column + j]) if (@column + j).between?(0, 7) &&
                                                   (@row + i).between?(0, 7) &&
                                                   (box_open?(@row + i, @column + j) ||
                                                    get_piece(@row + i, @column + j).color != @color)
      end
    end
    moves_arr
  end

  def protect_king_moves
    moves_arr = []
    [-1, 0, 1].each do |i|
      [-1, 0, 1].each do |j|
        next if j == 0 && i == 0

        moves_arr.push([@row + i, @column + j]) if (@column + j).between?(0, 7) &&
                                                   (@row + i).between?(0, 7)
      end
    end
    moves_arr
  end
end

class Piece
  attr_reader :color

  include Moves
  def initialize(row, column, color, board)
    @row = row
    @column = column
    @color = color
    @board = board
  end

  def move(row, column)
    @board[@row][@column] = "."
    @board[row][column] = self
    @row = row
    @column = column
    true
  end

  def box_open?(row, column)
    @board[row][column] == "."
  end

  def get_piece(row, column)
    @board[row][column]
  end
end

class Pawn < Piece
  attr_reader :double_moved

  def initialize(row, column, color, board)
    super
    @moved = false
    @double_moved = false
    @multiplier = @color == "black" ? 1 : -1
  end

  def move(row, column)
    @double_moved = false if [-1, 1].include?(row - @row)
    @double_moved = true if [-2, 2].include?(row - @row)
    @board[row - @multiplier][column] = "." if @board[row][column] == "."
    return false unless super

    @moved = true
    true
  end

  def promote(type)
    case type
    when "queen"
      @board[@row][@column] = Queen.new(@row, @column, @color, @board)
    when "knight"
      @board[@row][@column] = Knight.new(@row, @column, @color, @board)
    when "rook"
      @board[@row][@column] = Rook.new(@row, @column, @color, @board)
    when "bishop"
      @board[@row][@column] = Bishop.new(@row, @column, @color, @board)
    end
  end

  def protect_moves
    arr = []
    arr += protect_pawn_eat_moves
    arr
  end

  def possible_moves
    arr = []
    arr += pawn_moves
    arr += pawn_eat_moves
    arr += en_passent_moves
    arr
  end

  def to_s
    @color == "black" ? 0x2659.chr("UTF-8") : 0x265F.chr("UTF-8")
  end
end

class Rook < Piece
  def initialize(row, column, color, board)
    super
  end

  def possible_moves
    arr = []
    arr += row_moves
    arr += column_moves
    arr
  end

  def protect_moves
    arr = []
    arr += protect_row_moves
    arr += protect_column_moves
    arr
  end

  def to_s
    @color == "black" ? 0x2656.chr("UTF-8") : 0x265C.chr("UTF-8")
  end
end

class Knight < Piece
  def initialize(row, column, color, board)
    super
  end

  def possible_moves
    knight_moves
  end

  def protect_moves
    protect_knight_moves
  end

  def to_s
    @color == "black" ? 0x2658.chr("UTF-8") : 0x265E.chr("UTF-8")
  end
end

class Bishop < Piece
  def initialize(row, column, color, board)
    super
  end

  def possible_moves
    arr = []
    arr += left_diagonal_moves
    arr += right_diagonal_moves
    arr
  end

  def protect_moves
    arr = []
    arr += protect_left_diagonal_moves
    arr += protect_right_diagonal_moves
    arr
  end

  def to_s
    @color == "black" ? 0x2657.chr("UTF-8") : 0x265D.chr("UTF-8")
  end
end

class Queen < Piece
  def initialize(row, column, color, board)
    super
  end

  def possible_moves
    arr = []
    arr += row_moves
    arr += column_moves
    arr += left_diagonal_moves
    arr += right_diagonal_moves
    arr
  end

  def protect_moves
    arr = []
    arr += protect_row_moves
    arr += protect_column_moves
    arr += protect_left_diagonal_moves
    arr += protect_right_diagonal_moves
    arr
  end

  def to_s
    @color == "black" ? 0x2655.chr("UTF-8") : 0x265B.chr("UTF-8")
  end
end

class King < Piece
  def initialize(row, column, color, board)
    super
  end

  def possible_moves
    king_moves
  end

  def protect_moves
    protect_king_moves
  end

  def to_s
    @color == "black" ? 0x2654.chr("UTF-8") : 0x265A.chr("UTF-8")
  end
end
