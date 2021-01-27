extends ChessPiece
class_name Pawn, "res://Images/pawn.png"

var never_moved : bool = true


func set_moved():
	never_moved = false


func get_available_moves():
	
	var enemy_positions  = Global.piece_positions("Black")
	var allies_positions = Global.piece_positions("White")
	var pieces_positions = Global.piece_positions()
	
	var candidates := []
	var x = grid_position.x
	var y = grid_position.y
	if !(Vector2(x, y - 1) in pieces_positions):
		candidates.append(Vector2(x, y - 1))
		if never_moved:
			if !(Vector2(x, y - 2) in pieces_positions):
				candidates.append(Vector2(x, y - 2))
	if Vector2(x - 1, y - 1) in enemy_positions:
		candidates.append(Vector2(x - 1, y - 1))
	if Vector2(x + 1 , y - 1) in enemy_positions:
		candidates.append(Vector2(x + 1, y - 1))

	return candidates

