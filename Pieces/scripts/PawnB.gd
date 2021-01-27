extends Pawn
class_name PawnB


func get_available_moves():
	
	var allies_positions  = Global.piece_positions("Black")
	var enemy_positions = Global.piece_positions("White")
	
	var candidates := []
	var x = grid_position.x
	var y = grid_position.y
	candidates.append(Vector2(x, y + 1))
	if never_moved:
		candidates.append(Vector2(x, y + 2))
	
	if Vector2(x - 1, y + 1) in enemy_positions:
		candidates.append(Vector2(x - 1, y + 1))
	if Vector2(x + 1 , y + 1) in enemy_positions:
		candidates.append(Vector2(x + 1, y + 1))

	var final := []
	for pos in candidates:
		if !(pos in allies_positions + enemy_positions):
			final.append(pos)
	return final
