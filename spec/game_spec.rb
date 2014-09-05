require 'spec_helper'
require_relative '../lib/tic_tac_toe/game'

describe Game do

  describe "#new" do
  	it "initializes its dependencies" do
      expect(subject.board).to be_instance_of Board
      expect(subject.player).to be_a Game::Player
      expect(subject.computer).to be_a Game::Player
    end	

    it "initializes it attributes" do
      expect(subject.computer.is_computer).to eq true
      expect(subject.instance_variable_get(:@winner)).to eq nil 
      expect(subject.instance_variable_get(:@current_turn)).to eq 1
    end
  end

  describe "#play" do
    it "calls methods to implement high level policy algorithm for game play" do
      expect(subject).to receive(:get_player_name)
      expect(subject).to receive(:show_begin_message)
      expect(subject).to receive(:start_playing)
      expect(subject).to receive(:show_result)
      expect(subject).to receive(:show_game_over_message)
      subject.play
    end
  end

  describe "#get_player_name" do
    before do 
      expect(subject).to receive(:print).with('Enter player name: ')
      allow(subject).to receive_message_chain(:gets, :chomp).and_return 'name'
    end

    it "asks player to input their name" do
      subject.get_player_name
    end

    it "sets players name" do
      expect(subject.player).to receive(:name=).with any_args
      subject.get_player_name
    end

    it "sets players symbol" do
      expect(subject.player).to receive(:sym=).with any_args
      subject.get_player_name
    end

    it "sets computers name" do
      expect(subject.computer).to receive(:name=).with any_args
      subject.get_player_name
    end

    it "sets computers symbol" do
      expect(subject.computer).to receive(:sym=).with any_args
      subject.get_player_name
    end
  end

  describe "#show_begin_message" do
    it "outputs a welcome message" do
      allow(subject.player).to receive(:name).and_return 'name'
      expect($stdout).to receive(:puts).twice.with '------------------------------'
      expect($stdout).to receive(:puts).with 'Welcome to my TicTacToe Game!!'
      expect($stdout).to receive(:puts).with "Thank you, name, it is the Computers turn."
      expect($stdout).to receive(:puts)
      subject.show_begin_message
    end
  end

  describe "#show_turn" do
    let(:player) { Game::Player.new('name', 'x', false) }

    it "shows what number turn it is" do
      expect(subject).to receive(:puts).with "Turn: 1"
      expect(subject).to receive(:print).with "name ('x') "
      subject.show_turn(player)
    end

    it "shows what player is up" do
      expect(subject).to receive(:puts).with "Turn: 1"
      expect(subject).to receive(:print).with "name ('x') "
      subject.show_turn(player)
    end
  end

  describe "Artificial Intelligence for computer obtaining at least a draw" do
    describe "#corner_available?" do
      let(:board) { subject.board }

      it "determines if there are any empty corner cells" do
        expect(subject.corner_available?).to eq true
        9.times { |cell| subject.board.grid[cell] = 'x' } # fill the grid
        expect(subject.corner_available?).to eq false
      end
    end

    describe "#pick_corner" do
      it "picks at random from available corners not adjacent to players edges(noncenter, noncorner spots)" do
        expect(subject.available_corners).to include(subject.pick_corner)
        origin = 0; right_top_corner = 2; right_edge = 5
        subject.board.grid[origin] = 'o'
        subject.board.grid[right_top_corner] = 'o'
        subject.board.grid[right_edge] = 'x'
        subject.player.sym = 'x'
        expect(subject.pick_corner).to eq(6)
      end
    end

    describe "#available_corners" do
      it "returns an array of available corners not adjacent to noncenter cells"
    end

    describe "#adjacent_to_noncenter_spot?(corner)" do
      it "determines if corner is empty and not adjacent to edges(noncenter, noncorner spots)"
    end

    describe "#empty_cell?(cell)" do
      it "determines if cell is empty" do
        cell = 1
        expect(subject.empty_cell?(cell)).to eq true
        subject.board.grid[1] = 'x'
        expect(subject.empty_cell?(cell)).to eq false
      end
    end 
  end

  #TODO: More unit tests on all methods for 100% coverage
end