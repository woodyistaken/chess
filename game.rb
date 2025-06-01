require_relative "board"

class Game
  def initialize(board = Board.new)
    @board = board
    @player = "white"
  end

  def play
    loop do
      setup
      loop do
        if @board.check?(@player)
          if @board.checkmate?(@player)
            @player = @player == "black" ? "white" : "black"
            puts "#{@player.capitalize} wins"
            break
          end
          force_block
        else
          if @board.stalemate?(@player)
            puts "Draw"
            break
          end
          play_round
        end
        @player = @player == "black" ? "white" : "black"
      end
      @board.print_board
      break unless play_again?
    end
  end

  def play_again?
    input = nil
    loop do
      puts "Play Again?(y/n)"
      input = gets.chomp.downcase
      break if input.length == 1 && %w[y n].include?(input)

      puts "Invalid input"
    end
    input == "y"
  end

  def setup
    @board.setup_board
    @player = "white"
  end

  def force_block
    @board.print_board
    puts "#{@player.capitalize}'s turn"
    puts "You are in check"
    coords = choose_blocking_piece
    print_blocking_moves(coords[0], coords[1])
    move_coords = choose_blocking_move(coords[0], coords[1])
    move(coords, move_coords)
    promote_pawns
  end

  def play_round
    @board.print_board
    puts "#{@player.capitalize}'s turn"
    coords = choose_piece
    print_moves(coords[0], coords[1])
    move_coords = choose_move(coords[0], coords[1])
    move(coords, move_coords)
    promote_pawns
  end

  def promote_pawns
    promote = @board.check_promotion
    return if promote.nil?

    type = get_type
    @board.promote_pawn(promote[0], promote[1], type)
  end

  def get_type
    type = nil
    loop do
      puts "Promote to (queen,knight,rook,bishop)"
      type = gets.chomp.downcase
      break if %w[queen knight rook bishop].include?(type)
    end
    type
  end

  def choose_blocking_piece
    puts "Select Piece"
    coords = nil
    loop do
      coords = choose_box
      break if !@board.box_open?(coords[0], coords[1]) &&
               @board.get_color(coords[0], coords[1]) == @player &&
               !@board.get_moves(coords[0], coords[1]).empty? &&
               !@board.piece_block(coords[0], coords[1]).empty?

      puts !@board.piece_block(coords[0], coords[1]).empty?
      puts "Invalid Input"
    end
    coords
  end

  def print_blocking_moves(row, column)
    print @board.piece_block(row, column)
    puts
  end

  def choose_blocking_move(row, column)
    puts "Select Move"
    coords = nil
    loop do
      coords = choose_box
      break if @board.piece_block(row, column).include?(coords)

      puts "Invalid input"
    end
    coords
  end

  def choose_piece
    puts "Select Piece"
    coords = nil
    loop do
      coords = choose_box
      break if !@board.box_open?(coords[0], coords[1]) &&
               @board.get_color(coords[0], coords[1]) == @player &&
               !@board.get_moves(coords[0], coords[1]).empty? &&
               !@board.no_check_moves(coords[0], coords[1], @player).empty?

      puts "Invalid Input"
    end
    coords
  end

  def choose_box
    row = -1, column = -1
    row = input_coords("row").to_i
    column = input_coords("column").to_i
    [row, column]
  end

  def input_coords(type)
    coord = -1
    loop do
      print "#{type.capitalize}: "
      coord = gets.chomp.downcase

      break if check_coord_input(coord)

      puts "Invalid Input"
    end
    coord
  end

  def check_coord_input(str)
    return false if str.length != 1 || !%w[0 1 2 3 4 5 6 7].include?(str)

    true
  end

  def print_moves(row, column)
    print @board.no_check_moves(row, column, @player)
    puts
  end

  def choose_move(row, column)
    puts "Select Move"
    coords = nil
    loop do
      coords = choose_box
      break if @board.no_check_moves(row, column, @player).include?(coords)

      puts "Invalid input"
    end
    coords
  end

  def move(old_coords, new_coords)
    @board.move(old_coords[0], old_coords[1], new_coords[0], new_coords[1])
  end
end
