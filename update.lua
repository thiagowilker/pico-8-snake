function _update60()
	if (game_over) then
		update_game_over()
	else
		update_game()
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
	if (frame != move_speed) return

	x, y = get_next_move_coordinates()
	frame = 0
	loading_move = false

	update_moves(x, y)
end

function is_opposite_offset(value)
	if (value == "left") return offset == "right"
	if (value == "right") return offset == "left"
	if (value == "up") return offset == "down"
	if (value == "down") return offset == "up"
end

function is_same_or_opposite_offset(value)
    return value == offset or is_opposite_offset(value)
end

function set_offset(value)
	if (is_same_or_opposite_offset(value)) return

	offset = value
	loading_move = true

	sfx(0)
end

function handle_btn_press()
	if (loading_move) return

	if (btnp(⬅️)) set_offset("left")
	if (btnp(➡️)) set_offset("right")
	if (btnp(⬆️)) set_offset("up")
	if (btnp(⬇️)) set_offset("down")
end

function get_rnd_coordinate()
	return sqr * ceil(rnd(14))
end

function is_valid_coordinates(x, y)
	is_valid = true

	for move in all(moves) do
		if (x == move.x and y == move.y) is_valid = false
	end

	return is_valid
end

function get_next_point_coordinates()
	x = get_rnd_coordinate()
	y = get_rnd_coordinate()

	if (is_valid_coordinates(x, y)) return x, y

	return get_next_point_coordinates()
end

function hit_point_at_coordinates(x, y)
	return x == point_x and y == point_y
end

function add_move_at_coordinates(x, y)
	add(moves, {x = x, y = y, offset = offset})
end

function add_point()
	x, y = get_next_point_coordinates()
	score += 1
	point_x = x
	point_y = y
end

function handle_hit_poit_at_coordinates(x, y)
    add_move_at_coordinates(x, y)
	add_point()
	sfx(1)
end

function del_first_move()
	deli(moves, 1)
end

function is_in_dead_zone()
    min_valid_coordinate_value = 0
    max_valid_coordinate_value = 120

	return x == min_valid_coordinate_value or y == min_valid_coordinate_value or x == max_valid_coordinate_value or y == max_valid_coordinate_value
end

function is_game_over_at_coordinates(x, y)
    return not is_valid_coordinates(x, y) or is_in_dead_zone()
end

function update_moves(x, y)
	if (is_game_over_at_coordinates(x, y)) then game_over = true return end

    if (hit_point_at_coordinates(x, y)) return handle_hit_poit_at_coordinates(x, y)

	del_first_move()
	add_move_at_coordinates(x, y)
end

function update_game()
	frame += 1

	handle_btn_press()
	handle_move()
end

function update_game_over()
    if (btnp(❎)) run()
end
