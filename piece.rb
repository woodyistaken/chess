class Piece
  attr_reader :color

  def initialize(row, column, color, board)
    @row = row
    @column = column
    @color = color
    @board = board
  end

  def death
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
    @multipler = @color == "black" ? 1 : -1
  end

  def move(row, column)
    @row = row
    @column = column
  end

  def possible_moves
    arr = []
    arr += free_moves
    arr += eat_moves
    arr += en_passent_moves
    arr
  end

  def free_moves
    arr = []
    if box_open?(@row + @multipler, @column)
      arr.push([@row + @multipler, @column])
      arr.push([@row + (2 * @multipler), @column]) if box_open?(@row + (2 * @multipler), @column) && @moved == false
    end
    arr
  end

  def eat_moves
    arr = []
    [-1, 1].each do |i|
      arr.push([@row + @multipler, @column + i]) if !box_open?(@row + @multipler, @column + i) &&
                                                    get_piece(@row + @multipler, @column + i).color != @color
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

      arr.push([@row, @column + i])
    end
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

  def row_moves
    arr = []
    (1..7).each do |i|
      break if @row + i > 7

      arr.push([@row + i, @column])
      break unless box_open?(@row + i, @column)
    end
    (1..7).each do |i|
      break if @row - i < 0

      arr.push([@row - i, @column])
      break unless box_open?(@row - i, @column)
    end
    arr
  end

  def column_moves
    arr = []
    (1..7).each do |i|
      break if @column + i > 7

      arr.push([@row, @column + i])
      break unless box_open?(@row, @column + i)
    end
    (1..7).each do |i|
      break if @column - i < 0

      arr.push([@row, @column - i])
      break unless box_open?(@row, @column - i)
    end
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

  def left_diagonal_moves
    arr = []
    (1..7).each do |i|
      break if @row + i > 7 || @column + i > 7

      arr.push([@row + i, @column + i])
      break unless box_open?(@row + i, @column + i)
    end
    (1..7).each do |i|
      break if @row - i < 0 || @column - i < 0

      arr.push([@row - i, @column - i])
      break unless box_open?(@row - i, @column - i)
    end
    arr
  end

  def right_diagonal_moves
    arr = []
    (1..7).each do |i|
      break if @column + i > 7 || @row - i < 0

      arr.push([@row - i, @column + i])
      break unless box_open?(@row - i, @column + i)
    end
    (1..7).each do |i|
      break if @column - i < 0 || @row + i > 7

      arr.push([@row + i, @column - i])
      break unless box_open?(@row + i, @column - i)
    end
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

  def to_s
    @color == "black" ? 0x2655.chr("UTF-8") : 0x265B.chr("UTF-8")
  end
end

class King < Piece
  def initialize(row, column, color, board)
    super
  end

  def to_s
    @color == "black" ? 0x2654.chr("UTF-8") : 0x265A.chr("UTF-8")
  end
end
