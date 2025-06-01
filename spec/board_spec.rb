require_relative "../board"

describe Board do
  let(:board_arr) { Array.new(8) { Array.new(8) { "." } } }
  subject(:board) { Board.new(board_arr) }
  describe "#check?" do
    context "given  starting setup" do
      before do
        board.setup_board
      end
      it "return false" do
        expect(board.check?("black")).to be false
      end
    end
    context "given king in check with pawn" do
      before do
        board_arr[1][1] = King.new(1, 1, "black", board_arr)
        board_arr[2][2] = Pawn.new(2, 2, "white", board_arr)
      end
      it "return true" do
        expect(board.check?("black")).to be true
      end
    end
  end
  describe "#get_king_squares" do
    context "given checked king" do
      before do
        board_arr[1][1] = King.new(1, 1, "black", board_arr)
        board_arr[0][0] = Queen.new(0, 0, "white", board_arr)
      end
      it "no invalid move" do
        expect(board.get_king_squares("black").include?([2, 2])).to be false
      end
      it "return valid move" do
        expect(board.get_king_squares("black").include?([1, 2])).to be true
      end
      it "eat queen" do
        expect(board.get_king_squares("black").include?([0, 0])).to be true
      end
    end
    context "given unchecked quen" do
      before do
        board_arr[1][2] = King.new(1, 2, "black", board_arr)
        board_arr[0][0] = Queen.new(0, 0, "white", board_arr)
      end
      it "can't move into queen line of sight" do
        expect(board.get_king_squares("black").include?([2, 2])).to be false
      end
    end
  end
  describe "#checkmate?" do
    context "given starting setup" do
      before do
        board.setup_board
      end
      it "return false" do
        expect(board.checkmate?("black")).to be false
      end
    end
    context "given checkmated king" do
      before do
        board_arr[1][1] = King.new(1, 1, "black", board_arr)
        board_arr[2][0] = Queen.new(2, 0, "white", board_arr)
        board_arr[0][0] = Queen.new(0, 0, "white", board_arr)
        board_arr[2][2] = Queen.new(2, 2, "white", board_arr)
      end
      it "return true" do
        expect(board.checkmate?("black")).to be true
      end
    end
    context "given checkmated king block protection" do
      before do
        board_arr[1][1] = King.new(1, 1, "black", board_arr)
        board_arr[0][0] = Queen.new(0, 0, "white", board_arr)
        board_arr[2][2] = Queen.new(2, 2, "white", board_arr)
      end
      it "return true" do
        expect(board.checkmate?("black")).to be true
      end
    end
  end
  describe "#check_promotion" do
    context "no promoting pawn" do
      before do
        board_arr[1][0] = Pawn.new(1, 0, "white", board_arr)
      end
      it "return nil" do
        expect(board.check_promotion).to be_nil
      end
    end
    context "given promoting pawn" do
      before do
        board_arr[0][0] = Pawn.new(0, 0, "white", board_arr)
      end
      it "return pawn coordinates" do
        expect(board.check_promotion).to eq([0, 0])
      end
    end
  end
end
