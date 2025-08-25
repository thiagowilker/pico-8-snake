function _draw()
	cls(6)
	rect(8, 8, 119, 119, 0)

	if (game_over) then
		draw_game_over()
	else
		draw_game()
	end
end

function get_spr_data_for_first_move()
	move = moves[1]
	current_offset = move.offset
	is_moving_straight = current_offset == next_offset
	data = {
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

    return data[current_offset]
end

function get_spr_data_for_move_at_index(i)
	move = moves[i]
	current_offset = move.offset
	data = {
		left = { x = move.x + 2, y = move.y + 2, w = 1, h = 0.5 },
		right = { x = move.x - 2, y = move.y + 2, w = 1, h = 0.5 },
		up = { x = move.x + 2, y = move.y + 2, w = 0.5, h = 1 },
		down = { x = move.x + 2, y = move.y - 2, w = 0.5, h = 1 }
	}

    return data[current_offset]
end

function render_move_at_index(i)
    is_first_move = i == 1
	data = {}

	if (is_first_move) then
		data = get_spr_data_for_first_move()
	else
		data = get_spr_data_for_move_at_index(i)
	end

	spr(1, data.x, data.y, data.w, data.h)
end

function render_moves()
	for i=1, #moves do
		render_move_at_index(i)
	end
end

function render_point(x, y)
	spr(0, x, y)
end

function draw_game()
	render_point(point_x, point_y)
	render_moves()
end

function draw_game_over()
    print("game  over", 44, 48)
	print("score:", 44, 56)
	print(score, 72, 56)
	print("press ❎ to try again", 24, 72)
end
