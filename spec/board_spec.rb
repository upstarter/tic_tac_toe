require 'spec_helper'
require_relative '../lib/tic_tac_toe/board'
require_relative '../lib/tic_tac_toe/game'

describe Board do

  describe "#new" do
    it "initializes it attributes" do
      expect(subject.empty_cell).not_to be_empty
      expect(subject.empty_cell).to be_a String

      expect(subject.grid).not_to be_empty
      expect(subject.grid).to be_a Object
    end
  end

  describe "#print_grid" do
    it "prints a 3 X 3 grid sandwiched between new lines with empty cell markers" do
      expect($stdout).to receive(:puts).exactly(2).times.with("\n")
      expect($stdout).to receive(:puts).exactly(3).times.with("- | - | -")
      subject.print_grid
    end
  end

  describe "#update" do
    let(:player) { Game::Player.new('Fred', 'x', false) }

    context "when given valid cell (1-9)" do
      it "sets grid position to players symbol" do
        expect(subject.grid).to receive(:[]=) do |pos, sym|
          expect(pos).to be_an Integer
          expect(sym).to be_an String
        end
        subject.update(1, 'o')
      end

      it "returns true" do
        expect(subject.update(1, player.sym)).to eq true
      end
    end

    context "when given invalid cell (not 1-9)" do
      it "returns false" do
        expect(subject.update(10, player.sym)).to eq false
      end
    end
  end

end