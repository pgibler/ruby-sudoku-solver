require_relative 'board_row'
require_relative 'board_column'
require_relative 'board_zone'

# BoardState represents a configuration state for a Latin square.
#
# @see BoardRow
# @see BoardColumn
# @see BoardZone
class BoardState

  # Constants

  # Unassigned values equal 0 for the {FileProvider}
  UNASSIGNED_VALUE=0

  # Constructs a BoardState.
  #
  # @param board_array [Array<Array<Integer>>] A 9x9 array of integers for the Latin square. Top arrays stores columns, inner arrays store rows.
  def initialize(board_array)
    @board_array = board_array
  end

  # Returns the number at position (column, row)
  #
  # @param column [Integer] The column to check at.
  # @param row [Integer] The row to check at.
  def at(column, row)
    @board_array[column][row]
  end

  # Returns how many cells wide the board contained by BoardState is.
  #
  # @return [Integer] Returns how many cells wide the board contained by BoardState is.
  def width
    @board_array.length
  end

  # Returns how many cells tall the board contained by BoardState is.
  #
  # @return [Integer] Returns how many cells tall the board contained by BoardState is.
  def height
    @board_array[0].length
  end

  # Generates a new BoardState by updating the cell at position (column, height) with the new value.
  #
  # @param column [Integer] The column to check at.
  # @param row [Integer] The row to check at.
  # @param new_value [Object] New value to assign to position (column, height).
  #
  # @return [BoardState] Returns the updated BoardState.
  def update(column, row, new_value)
    # Duplicate the 2D board array
    new_board_array = Marshal.load(Marshal.dump(@board_array))

    # Assign the new value to the cell at (column, height).
    new_board_array[column][row] = new_value

    # Return a new BoardState with the updated array.
    BoardState.new(new_board_array)
  end

  # Returns the {BoardRow} that represents the row requested.
  #
  # @param number [Integer] The row number to get the {BoardRow} from.
  #
  # @return [BoardRow] Returns the {BoardRow} that represents the row requested.
  def row(number)
    BoardRow.new(generate_row_array(number))
  end

  # Returns the {BoardColumn} that represents the column requested.
  #
  # @param number [Integer] The column number to get the {BoardColumn} from.
  #
  # @return [BoardColumn] Returns the {BoardColumn} that represents the column requested.
  def column(number)
    BoardColumn.new(@board_array[number])
  end

  # Returns the {BoardZone}, a 3x3 subsection of the BoardState, around position (column, height).
  #
  # @param column [Integer] The column to check at.
  # @param row [Integer] The row to check at.
  #
  # @return [BoardZone] Returns the {BoardZone}, a 3x3 subsection of the BoardState, around position (column, height).
  def zone_at(column, row)
    BoardZone.new(generate_zone_array(column, row))
  end

  # Returns a multi-dimensional Array of rows with columns at each index.
  #
  # @return [Array<Array<Integer>>] Returns a multi-dimensional Array of rows with columns at each index.
  def to_row_array
    (0..height-1).map do |index|
      generate_row_array index
    end
  end

  # Returns the BoardState as represented by a String.
  #
  # @return [String] Returns the BoardState as represented by a String.
  def to_s
    to_row_array.map do |row|
      row.join(' ')
    end.join("\n")
  end

  # Invokes a method on each cell in the BoardState.
  #
  # @param block [Proc] The block to run on each cell.
  def each_cell(&block)
    (0..height-1).each do |row|
      (0..width-1).each do |column|
        block.call(column, row)
      end
    end
  end

  # Determines to see if a cell contains 0 or not.
  #
  # @param value [Object] The value of the cell being checked.
  #
  # @return [Boolean] Returns true if the value equals an unassigned value, otherwise false.
  def is_value_unassigned?(value)
    value == UNASSIGNED_VALUE
  end

  # Returns true if the BoardState is filled, otherwise, false.
  #
  # @return [Boolean] Returns true if the BoardState is filled, otherwise false.
  def filled?
    each_cell do |column, row|
      return false if is_value_unassigned? at(column, row)
    end

    # If there are no more 0 numbers, return #true.
    true
  end

  # Returns an Array containing the values that could be assigned to a cell.
  #
  # @return [Array<Integer>] Returns an Array containing the integers (1..9).
  def assignable_values
    (1..9)
  end

  private
  # Generates a row array from a row number.
  # Iterates through each column and pulls out the item at the specified row number in the column.
  #
  # @param number [Integer] The row number to generate the {BoardRow} from.
  #
  # @return [Array<Integer>] Returns an Array containing Integer values from the specified row number.
  def generate_row_array(number)
    @board_array.map { |column| column[number] }
  end

  # Generates a zone array from a (column, row) position.
  # Copies out the zone array from the {BoardState}.
  #
  # @param column [Integer] The column to check at.
  # @param row [Integer] The row to check at.
  #
  # @return [Array<Array<Integer>>] Returns a 3x3 multi-dimensional Array containing the sub-section of the BoardState.
  def generate_zone_array(column, row)
    # Get the bounds for the Array
    start_column, end_column = get_zone_column_bounds(column)
    start_row, end_row = get_zone_row_bounds(row)

    # Map out the Array and return it.
    (start_column..end_column).map do |column|
      (start_row..end_row).map do |row|
        @board_array[column][row]
      end
    end
  end

  # Gets the zone column bounds.
  #
  # @param column [Integer] The column of the zone where the bounds are being calculated.
  #
  # @return [(Integer, Integer)] Returns a tuple of (Integer, Integer) containing the column bounds.
  def get_zone_column_bounds(column)
    case
      when column >= 6
        return 6, 8
      when column >= 3
        return 3, 5
      else
        return 0, 2
    end
  end

  # Gets the zone row bounds.
  #
  # @param row [Integer] The row of the zone where the bounds are being calculated.
  #
  # @return [(Integer, Integer)] Returns a tuple of (Integer, Integer) containing the row bounds.
  def get_zone_row_bounds(row)
    case
      when row >= 6
        return 6, 8
      when row >= 3
        return 3, 5
      else
        return 0, 2
    end
  end

end