require_relative "../piece"

describe Pawn do
  describe "black pawn: #possible_moves" do
    let(:board) { Array.new(8) { Array.new(8) { "." } } }
    subject(:pawn) { described_class.new(1, 1, "black", board) }
    context "empty board with pawn" do
      before do
        board[1][1] = pawn
      end
      it "allow one square forward" do
        expect(pawn.possible_moves.include?([2, 1])).to be true
      end
      it "allow two square forward" do
        expect(pawn.possible_moves.include?([3, 1])).to be true
      end
      it "only two moves allowed" do
        expect(pawn.possible_moves.length).to eq(2)
      end
    end
    context "Board with pawn and target" do
      before do
        board[1][1] = pawn
        board[2][2] = Pawn.new(2, 2, "white", board)
        board[2][0] = Pawn.new(2, 0, "black", board)
      end
      it "eat right" do
        expect(pawn.possible_moves.include?([2, 2])).to be true
      end
      it "can't eat ally" do
        expect(pawn.possible_moves.include?([2, 0])).to be false
      end
      it "3 moves allowed" do
        expect(pawn.possible_moves.length).to eq(3)
      end
    end
    context "Board with pawn and en-passent target" do
      subject(:pawn) { Pawn.new(4, 1, "black", board) }
      before do
        board[4][1] = pawn
        board[4][2] = Pawn.new(4, 2, "white", board)
        board[4][2].instance_variable_set(:@double_moved, true)
        board[4][0] = Pawn.new(4, 0, "white", board)
        board[4][0].instance_variable_set(:@double_moved, true)
      end
      it "eat en-passent right" do
        expect(pawn.possible_moves.include?([4, 2])).to be true
      end
      it "eat en-passent left" do
        expect(pawn.possible_moves.include?([4, 0])).to be true
      end
      it "3 moves allowed" do
        expect(pawn.possible_moves.length).to eq(4)
      end
    end
  end
  describe "white pawn: #possible_moves" do
    let(:board) { Array.new(8) { Array.new(8) { "." } } }
    subject(:pawn) { described_class.new(7, 1, "white", board) }
    context "empty board with pawn" do
      before do
        board[7][1] = pawn
      end
      it "allow one square forward" do
        expect(pawn.possible_moves.include?([6, 1])).to be true
      end
      it "allow two square forward" do
        expect(pawn.possible_moves.include?([5, 1])).to be true
      end
      it "only two moves allowed" do
        expect(pawn.possible_moves.length).to eq(2)
      end
    end
    context "Board with pawn and target" do
      before do
        board[7][1] = pawn
        board[6][2] = Pawn.new(6, 2, "black", board)
        board[6][0] = Pawn.new(6, 0, "white", board)
      end
      it "eat right" do
        expect(pawn.possible_moves.include?([6, 2])).to be true
      end
      it "can't eat ally" do
        expect(pawn.possible_moves.include?([6, 0])).to be false
      end
      it "3 moves allowed" do
        expect(pawn.possible_moves.length).to eq(3)
      end
    end
    context "Board with pawn and en-passent target" do
      subject(:pawn) { Pawn.new(3, 1, "white", board) }
      before do
        board[3][1] = pawn
        board[3][2] = Pawn.new(3, 2, "black", board)
        board[3][2].instance_variable_set(:@double_moved, true)
        board[3][0] = Pawn.new(3, 0, "white", board)
        board[3][0].instance_variable_set(:@double_moved, true)
      end
      it "eat en-passent right" do
        expect(pawn.possible_moves.include?([3, 2])).to be true
      end
      it "can't eat ally" do
        expect(pawn.possible_moves.include?([3, 0])).to be false
      end
      it "3 moves allowed" do
        expect(pawn.possible_moves.length).to eq(3)
      end
    end
  end
end
describe Rook do
  describe "rook: #possible_moves" do
    let(:board) { Array.new(8) { Array.new(8) { "." } } }
    subject(:rook) { described_class.new(0, 0, "black", board) }
    context "empty board with rook" do
      before do
        board[0][0] = rook
      end
      it "returns 14 moves" do
        expect(rook.possible_moves.length).to eq(14)
      end
      it "contains valid move" do
        expect(rook.possible_moves.include?([0, 1])).to be true
        expect(rook.possible_moves.include?([1, 0])).to be true
      end
      it "does not contains valid move" do
        expect(rook.possible_moves.include?([1, 1])).to be false
      end
    end

    context "rook with obstacle" do
      before do
        board[0][0] = rook
        board[4][0] = Pawn.new(4, 0, "black", board)
        board[0][3] = Pawn.new(0, 3, "white", board)
      end
      it "returns 7 moves" do
        expect(rook.possible_moves.length).to eq(7)
      end
      it "blocked by white piece" do
        expect(rook.possible_moves.include?([0, 5])).to be false
      end
      it "blocked by black piece" do
        expect(rook.possible_moves.include?([5, 0])).to be false
      end
      it "include blocking piece" do
        expect(rook.possible_moves.include?([4, 0])).to be true
        expect(rook.possible_moves.include?([0, 3])).to be true
      end
    end
  end
end
describe Bishop do
  describe "bishop: #possible_moves" do
    let(:board) { Array.new(8) { Array.new(8) { "." } } }
    subject(:bishop) { described_class.new(4, 4, "black", board) }
    context "empty board with bishop" do
      before do
        board[4][4] = bishop
      end
      it "returns 13 moves" do
        expect(bishop.possible_moves.length).to eq(13)
      end
      it "contains valid move" do
        expect(bishop.possible_moves.include?([3, 3])).to be true
        expect(bishop.possible_moves.include?([3, 5])).to be true
      end
      it "does not contains valid move" do
        expect(bishop.possible_moves.include?([1, 0])).to be false
      end
    end

    context "bishop with obstacle" do
      before do
        board[4][4] = bishop
        board[2][2] = Pawn.new(2, 2, "black", board)
        board[2][6] = Pawn.new(2, 6, "white", board)
      end
      it "returns 10 moves" do
        expect(bishop.possible_moves.length).to eq(10)
      end
      it "blocked by white piece" do
        expect(bishop.possible_moves.include?([0, 0])).to be false
      end
      it "blocked by black piece" do
        expect(bishop.possible_moves.include?([1, 7])).to be false
      end
      it "include blocking piece" do
        expect(bishop.possible_moves.include?([2, 2])).to be true
        expect(bishop.possible_moves.include?([2, 6])).to be true
      end
    end
  end
end
