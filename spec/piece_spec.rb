require_relative "../piece"

describe Piece do
  let(:board) { Array.new(8) { Array.new(8) { "." } } }
  subject(:piece) { Pawn.new(1, 0, "black", board) }
  describe "#move" do
    context "given a piece" do
      before do
        board[1][0] = piece
      end
      it "move piece" do
        expect { piece.move(2, 0) }.to change { board[1][0] }.to(".").and change { board[2][0] }.to(piece)
      end
      it "invalid move return false" do
        expect(piece.move(2, 5)).to be false
      end
    end
  end
end

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
        board[4][0] = Pawn.new(4, 0, "black", board)
        board[4][0].instance_variable_set(:@double_moved, true)
      end
      it "eat en-passent right" do
        expect(pawn.possible_moves.include?([5, 2])).to be true
      end
      it "can't eat ally" do
        expect(pawn.possible_moves.include?([5, 0])).to be false
      end
      it "3 moves allowed" do
        expect(pawn.possible_moves.length).to eq(3)
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
        expect(pawn.possible_moves.include?([2, 2])).to be true
      end
      it "can't eat ally" do
        expect(pawn.possible_moves.include?([2, 0])).to be false
      end
      it "3 moves allowed" do
        expect(pawn.possible_moves.length).to eq(3)
      end
    end
  end
  describe "pawn after moving" do
    let(:board) { Array.new(8) { Array.new(8) { "." } } }
    subject(:pawn) { described_class.new(1, 1, "black", board) }
    context "pawn after one move" do
      before do
        pawn.move(2, 1)
      end
      it "can move forward once" do
        expect(pawn.possible_moves.include?([3, 1])).to be true
      end
      it "only one move" do
        expect(pawn.possible_moves.length).to eq(1)
      end
      it "double_moved is false" do
        expect(pawn.instance_variable_get(:@double_moved)).to be false
      end
    end
    context "pawn after double move" do
      before do
        pawn.move(3, 1)
      end
      it "can move forward once" do
        expect(pawn.possible_moves.include?([4, 1])).to be true
      end
      it "only one move" do
        expect(pawn.possible_moves.length).to eq(1)
      end
      it "double_moved is true" do
        expect(pawn.instance_variable_get(:@double_moved)).to be true
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
      it "returns 6 moves" do
        expect(rook.possible_moves.length).to eq(6)
      end
      it "blocked by white piece" do
        expect(rook.possible_moves.include?([0, 5])).to be false
      end
      it "blocked by black piece" do
        expect(rook.possible_moves.include?([5, 0])).to be false
      end
      it "include blocking opposing piece only" do
        expect(rook.possible_moves.include?([4, 0])).to be false
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
      it "returns 9 moves" do
        expect(bishop.possible_moves.length).to eq(9)
      end
      it "blocked by white piece" do
        expect(bishop.possible_moves.include?([0, 0])).to be false
      end
      it "blocked by black piece" do
        expect(bishop.possible_moves.include?([1, 7])).to be false
      end
      it "include blocking enemy piece only" do
        expect(bishop.possible_moves.include?([2, 2])).to be false
        expect(bishop.possible_moves.include?([2, 6])).to be true
      end
    end
  end
end
describe Knight do
  describe "knight: #possible_moves" do
    let(:board) { Array.new(8) { Array.new(8) { "." } } }
    subject(:knight) { described_class.new(4, 4, "black", board) }
    context "empty board with knight" do
      before do
        board[4][4] = knight
      end
      it "returns 8 moves" do
        expect(knight.possible_moves.length).to eq(8)
      end
      it "contains valid move" do
        expect(knight.possible_moves.include?([5, 6])).to be true
        expect(knight.possible_moves.include?([2, 3])).to be true
      end
      it "does not contains valid move" do
        expect(knight.possible_moves.include?([1, 0])).to be false
      end
    end

    context "knight on edge" do
      subject(:knight) { described_class.new(0, 0, "black", board) }
      before do
        board[0][0] = knight
      end
      it "returns 2 moves" do
        expect(knight.possible_moves.length).to eq(2)
      end
    end
    context "knight with ally" do
      subject(:knight) { described_class.new(0, 0, "black", board) }
      before do
        board[0][0] = knight
        board[2][1] = Knight.new(2, 1, "black", board)
      end
      it "can't eat ally" do
        expect(knight.possible_moves.include?([2, 1])).to be false
      end
    end
  end
end
describe Queen do
  describe "queen: #possible_moves" do
    let(:board) { Array.new(8) { Array.new(8) { "." } } }
    subject(:queen) { described_class.new(4, 4, "black", board) }
    context "empty board with queen" do
      before do
        board[4][4] = queen
      end
      it "returns 27 moves" do
        expect(queen.possible_moves.length).to eq(27)
      end
    end

    context "queen with obstacle in row/column" do
      subject(:queen) { described_class.new(0, 0, "black", board) }
      before do
        board[0][0] = queen
        board[4][0] = Pawn.new(4, 0, "black", board)
        board[0][3] = Pawn.new(0, 3, "white", board)
      end
      it "returns 13 moves" do
        expect(queen.possible_moves.length).to eq(13)
      end
      it "blocked by white piece" do
        expect(queen.possible_moves.include?([0, 5])).to be false
      end
      it "blocked by black piece" do
        expect(queen.possible_moves.include?([5, 0])).to be false
      end
      it "include blocking enemy piece only" do
        expect(queen.possible_moves.include?([4, 0])).to be false
        expect(queen.possible_moves.include?([0, 3])).to be true
      end
    end
    context "queen with obstacle in diagonal" do
      subject(:queen) { described_class.new(4, 4, "black", board) }
      before do
        board[4][4] = queen
        board[2][2] = Pawn.new(2, 2, "black", board)
        board[2][6] = Pawn.new(2, 6, "white", board)
      end
      it "returns 23 moves" do
        expect(queen.possible_moves.length).to eq(23)
      end
      it "blocked by white piece" do
        expect(queen.possible_moves.include?([0, 0])).to be false
      end
      it "blocked by black piece" do
        expect(queen.possible_moves.include?([1, 7])).to be false
      end
      it "include blocking enemy piece only" do
        expect(queen.possible_moves.include?([2, 2])).to be false
        expect(queen.possible_moves.include?([2, 6])).to be true
      end
    end
  end
end
describe King do
  describe "king: #possible_moves" do
    let(:board) { Array.new(8) { Array.new(8) { "." } } }
    subject(:king) { described_class.new(4, 4, "black", board) }
    context "empty board with king in middle" do
      before do
        board[4][4] = king
      end
      it "returns 8 moves" do
        expect(king.possible_moves.length).to eq(8)
      end
      it "returns valid move" do
        expect(king.possible_moves.include?([5, 4])).to be true
      end
      it "no invalid move" do
        expect(king.possible_moves.include?([6, 4])).to be false
      end
    end

    context "king in corner" do
      subject(:king) { described_class.new(0, 0, "black", board) }
      before do
        board[0][0] = king
      end
      it "returns 3 moves" do
        expect(king.possible_moves.length).to eq(3)
      end
    end
    context "king with ally" do
      subject(:king) { described_class.new(0, 0, "black", board) }
      before do
        board[0][0] = king
        board[1][1] = Pawn.new(1, 1, "black", board)
      end
      it "can't eat ally" do
        expect(king.possible_moves.include?([1, 1])).to be false
      end
    end
  end
end
