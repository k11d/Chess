extends ChessPiece
class_name Pawn, "res://Images/pawn.png"

var never_moved : bool = true


func set_moved():
	never_moved = false


func get_available_moves():
	if piece_color == "White":
		return _as_white()
	else:
		return _as_black()


func _as_white():
	var allies_positions = Global.piece_positions("White")
	var enemy_positions = Global.piece_positions("Black")
	
	var candidates := []
	var x = grid_position.x
	var y = grid_position.y
	var pos : Vector2
	pos = Vector2(x,y - 1)
	if !(pos in allies_positions or pos in enemy_positions):
		candidates.append(pos)
		if never_moved:
			pos = Vector2(x, y - 2)
			if !(pos in allies_positions or pos in enemy_positions):
				candidates.append(pos)
	pos = Vector2(x - 1, y - 1)
	if pos in enemy_positions:
		candidates.append(pos)
	pos = Vector2(x + 1 , y - 1)
	if pos in enemy_positions:
		candidates.append(pos)
	return candidates

func _as_black():
	var allies_positions = Global.piece_positions("Black")
	var enemy_positions = Global.piece_positions("White")
	
	var candidates := []
	var x = grid_position.x
	var y = grid_position.y
	var pos : Vector2
	pos = Vector2(x,y + 1)
	if !(pos in allies_positions or pos in enemy_positions):
		candidates.append(pos)
		if never_moved:
			pos = Vector2(x, y + 2)
			if !(pos in allies_positions or pos in enemy_positions):
				candidates.append(pos)
	pos = Vector2(x + 1, y + 1)
	if pos in enemy_positions:
		candidates.append(pos)
	pos = Vector2(x - 1 , y + 1)
	if pos in enemy_positions:
		candidates.append(pos)
	return candidates
