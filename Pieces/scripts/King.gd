tool
extends ChessPiece
class_name King, "res://Images/king.png"



func get_available_moves():
	var allies_positions = Global.piece_positions(piece_color)
	var enemy_positions
	if piece_color == 'White':
		enemy_positions = Global.piece_positions('Black')
	else:
		enemy_positions = Global.piece_positions('White')

	var candidates := _targets_wrapper.new()
	var p := Vector2(grid_position.x, grid_position.y)
	# E
	p = Vector2(grid_position.x, grid_position.y)
	p.x -= 1
	if !(p in allies_positions):
		if p in enemy_positions:
			candidates.add_target(p, Color.red)
		else:
			candidates.add_target(p, Color.blue)
	# W
	p = Vector2(grid_position.x, grid_position.y)
	p.x += 1
	if !(p in allies_positions):
		if p in enemy_positions:
			candidates.add_target(p, Color.red)
		else:
			candidates.add_target(p, Color.blue)
	# N
	p = Vector2(grid_position.x, grid_position.y)
	p.y -= 1
	if !(p in allies_positions):
		if p in enemy_positions:
			candidates.add_target(p, Color.red)
		else:
			candidates.add_target(p, Color.blue)
	# S
	p = Vector2(grid_position.x, grid_position.y)
	p.y -= 1
	if !(p in allies_positions):
		if p in enemy_positions:
			candidates.add_target(p, Color.red)
		else:
			candidates.add_target(p, Color.blue)
	# SE
	p = Vector2(grid_position.x, grid_position.y)
	p.y -= 1
	p.x += 1
	if !(p in allies_positions):
		if p in enemy_positions:
			candidates.add_target(p, Color.red)
		else:
			candidates.add_target(p, Color.blue)
	# SW
	p = Vector2(grid_position.x, grid_position.y)
	p.y -= 1
	p.x -= 1
	if !(p in allies_positions):
		if p in enemy_positions:
			candidates.add_target(p, Color.red)
		else:
			candidates.add_target(p, Color.blue)
	# NW
	p = Vector2(grid_position.x, grid_position.y)
	p.y -= 1
	p.x -= 1
	if !(p in allies_positions):
		if p in enemy_positions:
			candidates.add_target(p, Color.red)
		else:
			candidates.add_target(p, Color.blue)
	# NE
	p = Vector2(grid_position.x, grid_position.y)
	p.y -= 1
	p.x += 1
	if !(p in allies_positions):
		if p in enemy_positions:
			candidates.add_target(p, Color.red)
		else:
			candidates.add_target(p, Color.blue)

	var _attacking_enemy = get_attacking_enemy(grid_position)
	if _attacking_enemy:
		print(str(self), " under attack of ", _attacking_enemy)
		var backup = grid_position
		for pos in candidates.targets:
			print("Simulating with:", pos)
			var attacking_enemy = self.get_attacking_enemy(pos)
			if attacking_enemy:
				print(str(self), " under attack of ", attacking_enemy)
			else:
				print("Found a valid target: ", pos)
		grid_position = backup
	return candidates

func get_attacking_enemy(virtual_pos) -> ChessPiece:
	var backup = grid_position
	grid_position = virtual_pos
	Global.update_piece_position(self)
	var enemy_pieces
	if piece_color == "White":
		enemy_pieces = Global.pieces("Black")
	else:
		enemy_pieces = Global.pieces("White")
	var under_attack := false
	var attacker : ChessPiece = null
	for enemy in enemy_pieces:
		if under_attack:
			break
		if "King" in enemy.name:
			continue
		var enemy_targets : Targets = enemy.get_available_moves()
		for pos in enemy_targets.targets:
			if pos == grid_position:
				under_attack = true
				attacker = enemy
				break
	grid_position = backup
	Global.update_piece_position(self)
	return attacker
