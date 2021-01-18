extends ChessPiece
class_name Knight, "res://Images/knight.png"


func _ready():
	pname = "Knight"

func get_available_moves() -> Global.TargetedPositions:
	var x := grid_position.x
	var y := grid_position.y
	var candidates := [
		Vector2(x + 1, y - 2),
		Vector2(x - 1, y - 2),
		Vector2(x + 2, y - 1),
		Vector2(x + 2, y + 1),
		Vector2(x - 1, y + 2),
		Vector2(x - 2, y + 1),
		Vector2(x - 2, y - 1),
		Vector2(x + 1, y + 2)
	]
	targeted.clear()
	for pos in filter_out_of_grid(candidates):
		if !(pos in pieces_grid_positions(my_allies())):
			targeted.add(pos)
	return targeted
