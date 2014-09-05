class Board
  attr_reader :grid, :empty_cell
  
  def initialize
    @empty_cell = '-' # default value for empty cells
    @grid = Array.new(9, @empty_cell)
  end

  # tic tac toe is officially the 3 X 3 version of a game abstraction (hence the 3 letter name)
  def print_grid # prints 3 X 3 grid with values
    puts "\n"
    @grid.each_slice(3) { |row| puts row.join(' | ') }
    puts "\n"
  end

  def update(pos, sym)
    if @grid[pos] == @empty_cell
      @grid[pos] = sym
      return true
    else
      return false
    end
  end
end