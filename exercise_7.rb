input = File.readlines('exercise_7.input', chomp: true)

CRABS = input[0].split(',').map { |x| x.to_i }

def compute(part_string, alg)
	min_horizontal_pos = CRABS.min
	max_horizontal_pos = CRABS.max

	min_fuel = Float::INFINITY

	(min_horizontal_pos .. max_horizontal_pos).each do |position|
		min_fuel = [min_fuel, CRABS.reduce(0, &alg.call(position))].min
	end

	puts "Result #{part_string}: #{min_fuel}"
end

compute("Part One", Proc.new { |position| Proc.new { |acc, crab| acc + (crab - position).abs } }) 
compute("Part Two", Proc.new { |position| Proc.new { |acc, crab|
		cost = (crab - position).abs
		
		acc + (cost*(cost+1))/2
	}
}) 
