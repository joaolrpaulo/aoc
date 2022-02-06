input = File.readlines('exercise_9_sample.input', chomp: true)

MATRIX = input.map { |line| line.chars.map { |depth| { digit: depth.to_i, visited: false } } }
LOW_POINTS = []

def part_one!
	matrix_size = MATRIX.size - 1
	line_size = MATRIX[0].size - 1
	low_level_total_risk = 0
	
	MATRIX.each_with_index do |line, line_index|
		line.each_with_index do |digit, digit_index|
			surroundings = []

			# Corners
			if    line_index % matrix_size == 0 and digit_index % line_size == 0
				if line_index == 0
					surroundings << MATRIX[line_index + 1][digit_index]

					if digit_index == 0
						surroundings << MATRIX[line_index][digit_index + 1]
					else
						surroundings << MATRIX[line_index][digit_index - 1]
					end
				else
					surroundings << MATRIX[line_index -1][digit_index]

					if digit_index == 0
						surroundings << MATRIX[line_index][digit_index + 1]
					else
						surroundings << MATRIX[line_index][digit_index - 1]
					end
				end

			# Middle Cells Top / Bottom Rows
			elsif line_index % matrix_size == 0 and digit_index % line_size != 0
				surroundings << MATRIX[line_index][digit_index + 1]
				surroundings << MATRIX[line_index][digit_index - 1]

				if line_index == 0
					surroundings << MATRIX[line_index + 1][digit_index]
				else
					surroundings << MATRIX[line_index - 1][digit_index]
				end

			# Middle Cells of left / right edges
			elsif line_index % matrix_size != 0 and digit_index % line_size == 0
				surroundings << MATRIX[line_index + 1][digit_index]
				surroundings << MATRIX[line_index - 1][digit_index]

				if digit_index == 0
					surroundings << MATRIX[line_index][digit_index + 1]
				else
					surroundings << MATRIX[line_index][digit_index - 1]
				end

			# In middle & can move look in all directions.
			else
				surroundings << MATRIX[line_index + 1][digit_index]
				surroundings << MATRIX[line_index - 1][digit_index]
				surroundings << MATRIX[line_index][digit_index + 1]
				surroundings << MATRIX[line_index][digit_index - 1]
			end

			if digit[:digit] < surroundings.sort_by { |x| x[:digit] }.first[:digit]
				low_level_total_risk += digit[:digit] + 1 

				LOW_POINTS << { digit: digit[:digit], x: line_index, y: digit_index }
			end
		end
	end

	puts "Result Part One: #{low_level_total_risk}"
end

def part_two
	LOW_POINTS.each do |point|
		current_point = point

		if current_point[:digit] != 9
			puts current_point
		end
	end
end

part_one!
part_two
