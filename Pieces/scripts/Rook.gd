extends ChessPiece
class_name Rook, "res://Images/rook.png"


func get_available_moves():
	
	var enemy_positions  = Global.piece_positions("Black")
	var allies_positions = Global.piece_positions("White")
	var p : Vector2
	
	var targets := []
	# EAST
	p = Vector2(grid_position.x, grid_position.y)

	while p.x < 7 and !(p in allies_positions):
		p.x += 1
		if p in enemy_positions:
			targets.append(p)
			break
	
	# WEST			
	p = Vector2(grid_position.x, grid_position.y)
	while p.x > 0 and !(p in allies_positions):
		p.x -= 1
		if p in enemy_positions:
			targets.append(p)
			break
	

	# SOUTH		
	p = Vector2(grid_position.x, grid_position.y)	
	while p.y < 7 and !(p in allies_positions):
		p.y += 1
		if p in enemy_positions:
			targets.append(p)
			break
	
	# NORTH
	p = Vector2(grid_position.x, grid_position.y)	
	while p.y > 0 and !(p in allies_positions):
		p.y -= 1
		if p in enemy_positions:
			targets.append(p)
			break
	
	return targets

	
