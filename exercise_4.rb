input = File.readlines('exercise_4.input', chomp: true)

bingo_input = input.shift.split(',')

# Remove the first empty line
input.shift

bingo_boards = Array.new(input.tally[""] + 1) { [] }
bingo_board_index = 0

# Setup the board matrix
input.each do |line|
  if line.empty?
    bingo_board_index += 1
    next
  end

  line_elements = line.split(' ')

  bingo_boards[bingo_board_index] << line_elements.map { |x| { element: x, visited: false } }
end

# Structure that contains information related with each board status.
# Could be embedded alongside with the matrix in a single class, but the overhead :sad:
execution_status = Array.new(bingo_boards.size) { { board: -1, number: -1, finishing_order: -1 } }
finishing_order = -1

bingo_input.each do |number|
  bingo_boards.each_with_index do |board, board_index|
    # Ignore if board is already completed
    next if execution_status[board_index][:number] != -1

    board.each do |board_line|
      board_line.each do |board_element|
        if board_element[:element] == number
          board_element[:visited] = true
        end
      end
    end

    # A line is completed
    is_line_completed = board.any? { |board_line| board_line.all? { |x| x[:visited] } }

    if is_line_completed
      finishing_order += 1

      # Mark board has finished
      execution_status[board_index] = { board: board_index, number: number, finishing_order: finishing_order }
    end

    # Assuming that all the boards have the same size, otherwise it would be fair.
    (0 .. board.first.size - 1).each do |index|
      # Ignore if board is already completed
      next if execution_status[board_index][:number] != -1

      # A column is completed
      is_column_full = board.map { |board_line| board_line[index][:visited] }.all? { |x| x == true }

      if is_column_full
        finishing_order += 1

        # Mark board has finished
        execution_status[board_index] = { board: board_index, number: number, finishing_order: finishing_order }
      end
    end
  end
end

first_board = execution_status.select { |x| x[:finishing_order] == 0 }.first
last_board  = execution_status.select { |x| x[:finishing_order] == finishing_order }.first

def calculated_visited(board)
  total_unvisited = 0

  board.each do |board_line|
    board_line.each { |x| total_unvisited += x[:element].to_i if !x[:visited] }
  end

  total_unvisited
end

puts "Result Phase Two: #{calculated_visited(bingo_boards[first_board[:board]]) * first_board[:number].to_i}"
puts "Result Phase One: #{calculated_visited(bingo_boards[last_board[:board]]) * last_board[:number].to_i}"
