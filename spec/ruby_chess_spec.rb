require './lib/game'

describe Rook do
  describe "#offboard?" do
    it "returns false when on board" do
      rook = Rook.new('a1')
      expect(rook.offboard?(['a', '1'])).to be false
    end
    it "returns true when off board" do
      rook = Rook.new('a1')
      expect(rook.offboard?(['a', '9'])).to be true
    end
    it "returns true when off board" do
      rook = Rook.new('a1')
      expect(rook.offboard?(['z', '1'])).to be true
    end
  end
end