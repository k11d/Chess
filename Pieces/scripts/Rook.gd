extends ChessPiece
class_name Rook, "res://Images/rook.png"


func get_available_moves():
	var allies_positions = Global.piece_positions(piece_color)
	var enemy_positions
	if piece_color == "White":
		enemy_positions = Global.piece_positions("Black")
	else:
		enemy_positions = Global.piece_positions("White")
	
	var targets := []
	var p : Vector2
	var x = grid_position.x
	var y = grid_position.y
	
	# EAST
	p = Vector2(x, y)
	while p.x < 7:
		p.x += 1
		if p in allies_positions:
			break
		elif p in enemy_positions:
			targets.append(p)
			break
		else:
			targets.append(p)
	# WEST			
	p = Vector2(x, y)
	while p.x > 0:
		p.x -= 1
		if p in allies_positions:
			break
		elif p in enemy_positions:
			targets.append(p)
			break
		else:
			targets.append(p)
	# SOUTH		
	p = Vector2(x, y)
	while p.y < 7:
		p.y += 1
		if p in allies_positions:
			break
		elif p in enemy_positions:
			targets.append(p)
			break
		else:
			targets.append(p)
	# NORTH
	p = Vector2(x, y)
	while p.y > 0:
		p.y -= 1
		if p in allies_positions:
			break
		elif p in enemy_positions:
			targets.append(p)
			break
		else:
			targets.append(p)			
	return targets

	
