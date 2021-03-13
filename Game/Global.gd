extends Node2D

var board_state : Dictionary 


func register_board_state(gm : Dictionary) -> void:
	board_state = gm


func pieces(only_color=null) -> Array:
	var pcs := []
	for p in board_state.values():
		if p and only_color == null or p and only_color == p.piece_color:
			pcs.append(p)
	return pcs

func piece_positions(only_color=null) -> Array:
	var positions := []
	for pos in board_state:
		if only_color == null or board_state[pos] and only_color == board_state[pos].piece_color:
			positions.append(pos)
	return positions


func piece_at(grid_pos: Vector2) -> ChessPiece:
	var piece = null
	for p in pieces():
		if p.grid_position == grid_pos:
			piece  = p
			break
	return piece

class TurnState:
	
	var now_playing
	var state
	
	func _init():
		now_playing = "White"
		state = "ToPick"
	
	func _to_string() -> String:
		return now_playing + ' ' + str(state)
		
	func player_picked() -> void:
		state = 'ToPlay'
	
	func player_cancelled() -> void:
		state = 'ToPick'

	func player_played() -> void:
		match now_playing:
			'White':
				now_playing = 'Black'
			'Black':
				now_playing = 'White'
		state = "ToPick"

