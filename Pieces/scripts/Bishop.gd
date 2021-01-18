extends ChessPiece
class_name Bishop, "res://Images/bishop.png"

func _ready():
	pname = "Bishop"


func get_available_moves() -> Global.TargetedPositions:
	var allies = my_allies()
	var enemies = my_enemies()
	
	var candidates = []
	var x = grid_position.x
	var y = grid_position.y

	var p
	# NE
	while x > 0 and x < 7 and y > 0 and y < 7:
		x += 1
		y -= 1
		p = Vector2(x,y)
		if p in pieces_grid_positions(my_enemies()):
			candidates.append(Vector2(x, y))
			break
		if p in pieces_grid_positions(my_allies()):
			break
		candidates.append(Vector2(x, y))
	
	# NW
	x = grid_position.x
	y = grid_position.y
	while x > 0 and x < 7 and y > 0 and y < 7:
		x -= 1
		y -= 1
		p = Vector2(x,y)
		if p in pieces_grid_positions(my_enemies()):
			candidates.append(Vector2(x, y))
			break
		if p in pieces_grid_positions(my_allies()):
			break
		candidates.append(Vector2(x, y))
	
	# SE
	x = grid_position.x
	y = grid_position.y
	while x > 0 and x < 7 and y > 0 and y < 7:
		x += 1
		y += 1
		p = Vector2(x,y)
		if p in pieces_grid_positions(my_enemies()):
			candidates.append(Vector2(x, y))
			break
		if p in pieces_grid_positions(my_allies()):
			break
		candidates.append(Vector2(x, y))
	
	# SW
	x = grid_position.x
	y = grid_position.y
	while x > 0 and x < 7 and y > 0 and y < 7:
		x -= 1
		y += 1
		p = Vector2(x,y)
		if p in pieces_grid_positions(my_enemies()):
			candidates.append(Vector2(x, y))
			break
		if p in pieces_grid_positions(my_allies()):
			break
		candidates.append(Vector2(x, y))
	
	targeted.clear()
	for _p in candidates:
		targeted.add(_p)
	return targeted
