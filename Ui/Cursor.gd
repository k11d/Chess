extends Area2D
class_name Cursor, "res://Images/cursor.png"


onready var game := get_node('/root/Game')
onready var hud := get_node('/root/Game/HUD') 

var disabled : bool = false
var free_mode : bool = false
var movement_step
var hovering_piece setget set_hovering_piece
var selected_piece setget set_selected_piece
var legal_target_positions : Targets



func real2boardpos(pos, t_size=null):
	# For convienience - although using Game's method  
	return get_node("/root/Game").real2boardpos(pos, t_size)

func board2realpos(bp, t_size=null):
	# For convienience - although using Game's method  
	return get_node("/root/Game").board2realpos(bp, t_size)

func move_snapped(real_position : Vector2) -> void:
	# Note: `real_position` is not the final position of the cursor.
	# It will instead be snapped to the closest valid position within the grid.
	# (ie: on the closest tile's center)
	# Use `move_freely` for an arbitrary destination.
	var bp = self.real2boardpos(real_position, movement_step)
	bp.y = max(0, min(bp.y, 7))
	bp.x = max(0, min(bp.x, 7))
	if real2boardpos(position, movement_step) != bp:
		position = board2realpos(bp, movement_step)
		hud.update_on_hud_position(real_position, bp)

func move_freely(real_position : Vector2) -> void:
	# Moves the cursor to an arbitrary destination
	position = real_position
	hud.update_on_hud_position(real_position, null)


######################################################


func set_hovering_piece(p : ChessPiece):
	hovering_piece = p
	if hovering_piece:
		hud.set_legal_moves(str(hovering_piece.get_available_moves()))
	else:
		hud.set_legal_moves("")

func set_selected_piece(p):
	selected_piece = p
