input = File.readlines('exercise_8.input', chomp: true)

#               1, 7, 4, 8
UNIQUE_SIZES = [2, 3, 4, 7]

ENTRIES = input
	.map { |line| line.split(' | ')}
	.map { |line| { patterns: line[0].split(' ').map { |x| x.chars.sort.join } , digits: line[1].split(' ').map { |x| x.chars.sort.join } } }

def part_one
	sum_of_unique = ENTRIES.reduce(0) { |acc, entry|
		acc + entry[:digits].reduce(0) { |acc, digit| acc + (UNIQUE_SIZES.include?(digit.size) ? 1 : 0) }
	}

	puts "Result Part One: #{sum_of_unique}"
end

def part_two
	final_sum = ENTRIES.reduce(0) { |acc, entry|
		known_digits = entry[:patterns].select { |digit| UNIQUE_SIZES.include?(digit.size) }.sort_by { |digit| digit.size }
		entry_sequence_ordered = entry[:patterns].reject { |digit| UNIQUE_SIZES.include?(digit.size) }.sort_by { |digit| digit.size }
		
		one_chars = known_digits[0].chars
		four_chars = known_digits[2].chars

		digits_mapping = {
			known_digits[0] => 1,
			known_digits[2] => 4,
			known_digits[1] => 7,
			known_digits[3] => 8
		}

		entry_sequence_ordered.map do |pattern|
			pattern_chars = pattern.chars

			matches_four_pattern = pattern_chars & four_chars
			matches_one_pattern = pattern_chars & one_chars

			if pattern.size == 5
				if matches_one_pattern.size == 2 and matches_four_pattern.size == 3
					digits_mapping[pattern] = 3
				elsif matches_one_pattern.size == 1 and matches_four_pattern.size == 3
					digits_mapping[pattern] = 5
				else
					digits_mapping[pattern] = 2
				end
			else
				if matches_one_pattern.size == 2 and matches_four_pattern.size == 4
					digits_mapping[pattern] = 9
				elsif matches_one_pattern.size == 1 and matches_four_pattern.size == 3
					digits_mapping[pattern] = 6
				else
					digits_mapping[pattern] =  0
				end
			end
			
		end

		acc + entry[:digits].map { |x| digits_mapping[x] }.join.to_i
	}

	puts "Result Part Two: #{final_sum}"
end

part_one
part_two