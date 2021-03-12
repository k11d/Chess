extends ChessPiece
class_name Queen, "res://Images/queen.png"


func get_available_moves():
	var allies_positions = Global.piece_positions(piece_color)
	var enemy_positions
	if piece_color == "White":
		enemy_positions = Global.piece_positions("Black")
	else:
		enemy_positions = Global.piece_positions("White")

	var targets := _targets_wrapper.new()
	var p : Vector2
	var x = grid_position.x
	var y = grid_position.y
	
	# EAST
	p = Vector2(x, y)
	while p.x < 7:
		p.x += 1
		if p in allies_positions:
			break
		if p in enemy_positions:
			targets.add_target(p, Color.red, true)
			break
		targets.add_target(p, Color.blue, false)
	# WEST			
	p = Vector2(x, y)
	while p.x > 0:
		p.x -= 1
		if p in allies_positions:
			break
		elif p in enemy_positions:
			targets.add_target(p, Color.red, true)
			break
		targets.add_target(p, Color.blue, false)
	# SOUTH		
	p = Vector2(x, y)
	while p.y < 7:
		p.y += 1
		if p in allies_positions:
			break
		elif p in enemy_positions:
			targets.add_target(p, Color.red, true)
			break
		targets.add_target(p, Color.blue, false)
	# NORTH
	p = Vector2(x, y)
	while p.y > 0:
		p.y -= 1
		if p in allies_positions:
			break
		elif p in enemy_positions:
			targets.add_target(p, Color.red, true)
			break
		targets.add_target(p, Color.blue, false)

	# NE
	while x < 7 and y > 0:
		x += 1
		y -= 1
		p = Vector2(x,y)
		if p in enemy_positions:
			targets.add_target(p, Color.red, true)
			break
		if p in allies_positions:
			break
		targets.add_target(p, Color.blue, false)
	
	# NW
	x = grid_position.x
	y = grid_position.y
	while x > 0 and y > 0:
		x -= 1
		y -= 1
		p = Vector2(x,y)
		if p in enemy_positions:
			targets.add_target(p, Color.red, true)
			break
		if p in allies_positions:
			break
		targets.add_target(p, Color.blue, false)
	
	# SE
	x = grid_position.x
	y = grid_position.y
	while x < 7 and y < 7:
		x += 1
		y += 1
		p = Vector2(x,y)
		if p in enemy_positions:
			targets.add_target(p, Color.red, true)
			break
		if p in allies_positions:
			break
		targets.add_target(p, Color.blue, false)
	
	# SW
	x = grid_position.x
	y = grid_position.y
	while x > 0 and y < 7:
		x -= 1
		y += 1
		p = Vector2(x,y)
		if p in enemy_positions:
			targets.add_target(p, Color.red, true)
			break
		if p in allies_positions:
			break
		targets.add_target(p, Color.blue, false)
	return targets
