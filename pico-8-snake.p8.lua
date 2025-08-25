poke(0x5f5c, 255)

function _init()
	sqr = 8
	fps = 12
	frame = 0
	moves = {}
	offset = "right"
	loading_move = false
	point_x = 64
	point_y = 64
	score = 0
	
	set_initial_snake_moves()
end

function _update60()
	frame += 1
	
	handle_btn_press()
	handle_move()
end

function _draw()
	cls(6)
	rect(8, 8, 119, 119, 0)
	palt(7, true)
	palt(0, false)
	print(score, 8, 2)
	render_point(point_x, point_y)
	render_snake_moves()
end

function render_point(x, y)
	spr(0, x, y)
end

function add_move(x, y)
	add(moves, {x = x, y = y, offset = offset})
end

function del_move()
	deli(moves, 1)
end

function set_initial_snake_moves()
	for i = 0, 3 do
		x = sqr + sqr * i
		y = 112

		add_move(x, y, offset)
	end
end

function get_spr_data_from_first(move)
	current_offset = move.offset
	is_moving_straight = current_offset == next_offset

	return {
		left = {
			x = is_moving_straight and move.x - 2 or move.x + 2,
			y = move.y + 2,
			w = is_moving_straight and 1 or 0.5,
			h = 0.5 },
		right = {
			x = move.x + 2,
			y = move.y + 2,
			w = is_moving_straight and 1 or 0.5,
			h = 0.5
		},
		up = {
			x = move.x + 2,
			y = is_moving_straight and move.y - 2 or move.y + 2,
			w = 0.5,
			h = is_moving_straight and 1 or 0.5
		},
		down = {
			x = move.x + 2,
			y = move.y + 2,
			w = 0.5,
			h = is_moving_straight and 1 or 0.5
		},
	}
end

function get_spr_data_from(move)
	return {
		left = { x = move.x + 2, y = move.y + 2, w = 1, h = 0.5 },
		right = { x = move.x - 2, y = move.y + 2, w = 1, h = 0.5 },
		up = { x = move.x + 2, y = move.y + 2, w = 0.5, h = 1 },
		down = { x = move.x + 2, y = move.y - 2, w = 0.5, h = 1 }
	}
end

function get_spr_data_from_move_index(i)
	move = moves[i]
	is_first_move = i == 1
	current_offset = move.offset
	data = {}

	if (is_first_move) then
		data = get_spr_data_from_first(move)[current_offset]
	else
		data = get_spr_data_from(move)[current_offset]
	end

	return data.x, data.y, data.w, data.h
end

function render_snake_move(i)
	move = moves[i]
	x, y, w, h = get_spr_data_from_move_index(i)

	spr(1, x, y, w, h)
end

function render_snake_moves()
	for i=1, #moves do
		render_snake_move(i)
	end
end

function get_next_move_coordinates()
	x = moves[#moves].x
	y = moves[#moves].y

	if (offset == "left") x -= sqr

	if (offset == "right") x += sqr

	if (offset == "up") y -= sqr

	if (offset == "down") y += sqr

	return x, y
end

function handle_move()
	if (frame != fps) return

	x, y = get_next_move_coordinates()
	frame = 0
	loading_move = false

	update_moves(x, y)
end

function is_same_offset(value)
	return value == offset
end

function is_opposite_offset(value)
	if (value == "left") return offset == "right"
	if (value == "right") return offset == "left"
	if (value == "up") return offset == "down"
	if (value == "down") return offset == "up"
end

function handle_set_offset(value)
	is_same_or_opposite_offset_value = is_same_offset(value) or is_opposite_offset(value)

	if (is_same_or_opposite_offset_value) return

	offset = value
	loading_move = true

	sfx(0)
end

function handle_btn_press()
	if (loading_move == true) return

	if (btnp(0)) handle_set_offset("left")

	if (btnp(1)) handle_set_offset("right")

	if (btnp(2)) handle_set_offset("up")

	if (btnp(3)) handle_set_offset("down")
end

function get_rnd_point_coordinate()
	return sqr * ceil(rnd(14))
end

function is_valid_coordinates(x, y)
	for move in all(moves) do
		if (x == move.x and y == move.y) return false
	end

	return true
end

function get_next_point_coordinates()
	x = get_rnd_point_coordinate()
	y = get_rnd_point_coordinate()

	if (is_valid_coordinates(x, y)) return x, y

	return get_next_point_coordinates()
end

function add_point()
	x, y = get_next_point_coordinates()
	score += 1
	point_x = x
	point_y = y
end

function add_point_and_move(x, y)
	add_move(x, y)
	add_point()
	sfx(1)
end

function hit_point(x, y)
	return x == point_x and y == point_y
end

function is_on_dead_zone()
	return x == 0 or y == 0 or x == 120 or y == 120
end

function update_moves(x, y)
	if (hit_point(x, y)) return add_point_and_move(x, y)

	del_move()

	is_game_over = not is_valid_coordinates(x, y) or is_on_dead_zone()

	if (is_game_over) run()

	add_move(x, y)
end
