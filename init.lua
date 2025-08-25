poke(0x5f5c, 255)
palt(7, true)
palt(0, false)

function _init()
	sqr = 8
	move_speed = 6
	frame = 0
	offset = "right"
	moves = get_initial_moves()
	point_x = 64
	point_y = 64
	score = 0
	loading_move = false
	game_over = false
end

function get_initial_moves()
	initial_length = 3
	initial_x = 8
	initial_y = 112
	initial_moves = {}

	for i = 0, initial_length do
		x = initial_x + sqr * i
		y = initial_y

		add(initial_moves, {x = x, y = y, offset = offset})
	end

	return initial_moves
end
