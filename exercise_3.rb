array = File.readlines('exercise_3.input', chomp: true)

def find_factor(arr, alg)
	factors = arr.group_by(&:itself).values.send(alg, &:size)

	{
		number: factors.first,
		size: factors.size
	}
end

def transform_to_column_input(arr, bucket_size)
	column_inputs = Array.new(bucket_size) { [] }

	arr.each_char.with_index do |x, idx|
		column_inputs[idx % bucket_size].push x
	end

	column_inputs
end

def calculate_power_consumption(arr)
	gamma = ''
	epsilon = ''
	
	arr.each do |x|
		gamma += find_factor(x, :max_by)[:number]
		epsilon += find_factor(x, :min_by)[:number]
	end

	gamma.to_i(2) * epsilon.to_i(2)
end

def rating(arr, o2 = true)
	idx = 0
	alg = o2 ? :max_by : :min_by
	input = arr

	while input.size > 1
		column_input = transform_to_column_input(input.join, input[0].size)
		factor = find_factor(column_input[idx], alg)

		if input.size * 0.5 == factor[:size]
			if o2 
				factor[:number] = '1'
			else
				factor[:number] = '0'
			end
		end

		input = input.reject { |x| x[idx] != factor[:number] }

		idx += 1
	end

	input[0].to_i(2)
end

def calculate_life_support_rating(array)
	rating(array, true) * rating(array, false)
end

byte_string = array.join
column_input = transform_to_column_input(byte_string, array[0].size)
first_stage = calculate_power_consumption(column_input)
second_stage = calculate_life_support_rating(array)

puts first_stage.inspect
puts second_stage.inspect
