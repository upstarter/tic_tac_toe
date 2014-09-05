require_relative 'board'

class Game
  attr_reader :board, :player, :computer
  attr_accessor :current_turn
  # winning mappings
  @@wins =
    [[0, 1 ,2], 
     [3, 4, 5], 
     [6, 7, 8], # rows
     [0, 3, 6], [1, 4, 7], [2, 5, 8], # cols
     [0, 4, 8], [2, 4, 6]] # diagonals

  @@corners = [0,2,6,8]

  @@corner_adjacents = {
    0 => [1,3],
    2 => [1,5],
    6 => [3,7],
    8 => [5,7]
  }

  def initialize
    @board = Board.new
    @player = Player.new
    @computer = Player.new
    @computer.is_computer = true
    @winner = nil
    @current_turn = 1
  end

  def play
    get_player_name
    show_begin_message
    start_playing
    show_result
    show_game_over_message
  end

  def get_player_name
    print 'Enter player name: '
    @player.name = gets.chomp
    @player.sym = 'x'
    @computer.name = "Computer"
    @computer.sym = 'o'
  end

  def show_begin_message
    puts '------------------------------'
    puts 'Welcome to my TicTacToe Game!!'
    puts '------------------------------'
    puts "Thank you, #{@player.name}, it is the Computers turn."
    puts
  end

  def start_playing
    take_turns until game_over
  end

  def take_turns
    self.current_turn.even? ? turn(@player) : turn(@computer)
  end

  def turn(player)
    show_turn(player)
    input = if player.is_computer
              computer_turn
            else
              get_valid_cell
            end
    if input != "Blocked" && board.update(input, player.sym) 
      self.current_turn += 1
    elsif input == "Blocked"
      self.current_turn += 1
      msg = "OOH, OOH! BLOCKED FROM WIN!" unless @winner
    else
      msg = "SORRY, THAT CELL IS INVALID"
    end
    board.print_grid
    puts msg
    check_for_win(player)
  end

    # turn validation: requires user to input 1-9
  def get_valid_cell
    input = nil
    until (0..8).include?(input)
      print 'enter your move (1-9) top to bottom, left to right: '
      input = gets
      input = input.chomp.to_i.pred # array is indexed 0-8; positions are 1-9
    end
    input
  end

  # prints current player and turn number
  def show_turn(player)
    puts "Turn: #{self.current_turn}"
    print "#{player.name} ('#{player.sym}') "
  end

  def computer_turn
    pos = 0
    center = 4
    found = "F"

    # select winning cell for computer if it exists
    unless @winner
      check_rows(computer, found)
      check_cols(computer, found)
      check_diagonals(computer, found)

      # select winning cell for human if it exists
      check_rows(player, found)
      check_cols(player, found) 
      check_diagonals(player, found)
    end

    if found == "F"
      # if the center cell is available choose that
      if board.grid[center] == board.empty_cell
        center
      elsif corner_available? # if a corner is available 
        pick_corner # choose one that is not adjacent to player's noncenter cell(s); if none--choose a random one
      else # otherwise choose a random empty cell
        until empty_cell?(pos)
          pos = rand(board.grid.size)
        end
        pos
      end
    elsif found == "Blocked"
      found
    end
  end

  def corner_available?
    @@corners.any? {|corner| board.grid[corner] == board.empty_cell }
  end

  def pick_corner
    available_corners.sample || @@corners.select {|corner| board.grid[corner] == board.empty_cell }.sample
  end

  def available_corners
    @@corners.select do |corner|
      board.grid[corner] == board.empty_cell && !adjacent_to_noncenter_spot?(corner)
    end
  end

  def adjacent_to_noncenter_spot?(corner)
    @@corner_adjacents[corner].one? { |adjacent| board.grid[adjacent] == player.sym }
  end

  def empty_cell?(cell)
    board.grid[cell] == board.empty_cell
  end

  def check_rows(player, found)
    check_for_potential_win(player, @@wins[0..2], found)
    found.replace("T") if @winner && found != "Blocked"
  end

  def check_cols(player, found)
    check_for_potential_win(player, @@wins[3..5], found)
    found.replace("T") if @winner && found != "Blocked"
  end

  def check_diagonals(player, found)
    check_for_potential_win(player, @@wins[6..7], found)
    found.replace("T") if @winner && found != "Blocked"
  end

  # searches winning combos and assigns winner to current player
  def check_for_win(player)
    @@wins.each { |w| @winner = player if w.all? { |a| board.grid[a] == player.sym } }
  end

  # searches given winnable path on grid for winning situation
  def check_for_potential_win(player, paths, found)
    winning_path = paths.detect do |path|
      path.select { |cell| board.grid[cell] == player.sym }.size == 2 && 
      path.find {|cell| board.grid[cell] == board.empty_cell }
    end

    winning_cell = winning_path && winning_path.find {|cell| board.grid[cell] == board.empty_cell }
    if winning_cell
      board.update(winning_cell, computer.sym)
      found.replace("Blocked")
    end

    check_for_win(computer)
  end

  def game_over
    self.current_turn > 9 || @winner
  end

  def show_game_over_message
    puts '---------'
    puts 'Game Over'
    puts '---------'
  end

  def show_result
    if self.current_turn > 9 && !@winner
      puts "IT'S A TIE!"
    else
      puts "CONGRATULATIONS, #{@winner.name}.  YOU WON!"
    end
    board.print_grid
  end

  Player = Struct.new(:name, :sym, :is_computer)
end