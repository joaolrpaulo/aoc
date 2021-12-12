input = File.readlines('exercise_6.input', chomp: true)

DAYS_TO_SPAWN_CHILD = 6 # 7 Days counting to Day 0, where it spawns and resets
SIMULATION_DURATION_ONE = 79
SIMULATION_DURATION_TWO = 255

FISHES = input[0].split(',').map { |x| x.to_i }

def simulate(duration, part_string)
	fishes_by_day = Array.new(DAYS_TO_SPAWN_CHILD + 3) { 0 }

	FISHES.each do |fish|
		fishes_by_day[fish] += 1
	end

	(0 .. duration).each do |day|
		fishes_to_respawn = fishes_by_day.shift

		fishes_by_day << 0

		fishes_by_day[DAYS_TO_SPAWN_CHILD] += fishes_to_respawn
		fishes_by_day[DAYS_TO_SPAWN_CHILD + 2] += fishes_to_respawn
	end

	puts "Result #{part_string}: #{fishes_by_day.sum}"
end

simulate(SIMULATION_DURATION_ONE, "Part One")
simulate(SIMULATION_DURATION_TWO, "Part Two")
