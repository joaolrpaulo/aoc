input = File.readlines('exercise_5.input', chomp: true)

class Line
	class Point

		attr_reader :x, :y
		def initialize(input)
			x, y = input.split(',')

			@x = x.to_i
			@y = y.to_i
		end
	end

	attr_reader :from, :to

	def initialize(input)
		start_point, finish_point = input.split(' -> ')

		@from = Point.new(start_point)
		@to = Point.new(finish_point)
	end

	def further_from_root
		{ x: [from.x, to.x].max, y: [from.y, to.y].max }
	end

	def angle
		(Math.atan2(to.y - from.y, to.x - from.x) * 180 / Math::PI).abs
	end
end

lines = input.map { |line| Line.new(line) }

def visit_cells(lines, diagonals_enabled)
	# Compute the limit of the most distant point from 0,0
	further_point = {
		x: lines.map { |line| line.further_from_root[:x] }.max,
		y: lines.map { |line| line.further_from_root[:y] }.max
	}

	visited_table = Array.new(further_point[:x].to_i + 1) { Array.new(further_point[:y].to_i + 1) { 0 }}

	lines.each do |line|
		from_x = [line.from.x, line.to.x].min
		to_x = [line.from.x, line.to.x].max

		from_y = [line.from.y, line.to.y].min
		to_y = [line.from.y, line.to.y].max

		# Is the line horizontal or vertical?
		if [0, 90, 180, 270].include? line.angle
			(from_x .. to_x).each do |x|
				(from_y .. to_y).each do |y|
					visited_table[x][y] += 1
				end
			end
		# Are the diagonals enabled and the angle matches 45 degres?
		# (the 45 degree can be in any of the quadrants, depending
		# on the direction of the line vector.)
		elsif diagonals_enabled and [45, 135, 225, 315].include? line.angle
			x_step = line.from.x > line.to.x ? -1 : 1
			y_step = line.from.y > line.to.y ? -1 : 1

			x = line.from.x 
			y = line.from.y

			while x != line.to.x
				visited_table[x][y] += 1

				x += x_step
				y += y_step

			end

			# At the end be sure to mark the final point as visited
			visited_table[x][y] += 1
		end
	end

	visited_table
end

def compute(lines, part_string, diagonals_enabled)
	total_intersections = 0
	
	visit_cells(lines, diagonals_enabled).each do |line|
		line.each do |cell|
			total_intersections += 1 if cell > 1
		end
	end

	puts "Result #{part_string}: #{total_intersections}"
end


compute(lines, "Part One", false)
compute(lines, "Part One", true)
