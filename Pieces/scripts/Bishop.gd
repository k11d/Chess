extends ChessPiece
class_name Bishop, "res://Images/bishop.png"



func get_available_moves():
	
	var enemy_positions  = Global.piece_positions("Black")
	var allies_positions = Global.piece_positions("White")
	
	var candidates := []
	var x := grid_position.x
	var y := grid_position.y
	var p : Vector2
	
	# NE
	while x > 0 and x < 7 and y > 0 and y < 7:
		x += 1
		y -= 1
		p = Vector2(x,y)
		if p in enemy_positions:
			candidates.append(Vector2(x, y))
			break
		if p in allies_positions:
			break
		candidates.append(Vector2(x, y))
	
	# NW
	x = grid_position.x
	y = grid_position.y
	while x > 0 and x < 7 and y > 0 and y < 7:
		x -= 1
		y -= 1
		p = Vector2(x,y)
		if p in enemy_positions:
			candidates.append(Vector2(x, y))
			break
		if p in allies_positions:
			break
		candidates.append(Vector2(x, y))
	
	# SE
	x = grid_position.x
	y = grid_position.y
	while x > 0 and x < 7 and y > 0 and y < 7:
		x += 1
		y += 1
		p = Vector2(x,y)
		if p in enemy_positions:
			candidates.append(Vector2(x, y))
			break
		if p in allies_positions:
			break
		candidates.append(Vector2(x, y))
	
	# SW
	x = grid_position.x
	y = grid_position.y
	while x > 0 and x < 7 and y > 0 and y < 7:
		x -= 1
		y += 1
		p = Vector2(x,y)
		if p in enemy_positions:
			candidates.append(Vector2(x, y))
			break
		if p in allies_positions:
			break
		candidates.append(Vector2(x, y))
	
	return candidates
