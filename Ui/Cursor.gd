extends Area2D
class_name Cursor, "res://Images/cursor.png"


onready var game := get_node('/root/Game')
onready var HUDs := {
	grid_x_position = $HUD/Position/Grid/X,
	real_x_position = $HUD/Position/Real/X,
	grid_y_position = $HUD/Position/Grid/Y,
	real_y_position = $HUD/Position/Real/Y,
	current_player = $HUD/Game/Player,
	current_state = $HUD/Game/State,
	hovering = $HUD/Hovering,
	selected = $HUD/Selected
}
var disabled : bool = false
var movement_step setget set_movement_step
var hovering_piece setget set_hovering_piece
var selected_piece setget set_selected_piece
signal on_hovering_piece()

func set_movement_step(v):
	movement_step = v

func set_hovering_piece(p):
	hovering_piece = p
	if hovering_piece:
		HUDs['hovering'].text = str(hovering_piece)
		HUDs['hovering'].visible = true
	else:
		HUDs['hovering'].visible = false

func set_selected_piece(p):
	selected_piece = p
	if selected_piece:
		HUDs['selected'].text = str(hovering_piece)
		HUDs['selected'].visible = true
		var pos = selected_piece.global_position
		selected_piece.get_parent().remove_child(selected_piece)
		add_child(selected_piece)
		selected_piece.global_position = pos
	else:
		HUDs['selected'].visible = false

func update_on_hud_position(real_position=null, grid_position=null) -> void:
	if typeof(grid_position) == TYPE_VECTOR2:
		HUDs['grid_x_position'].text = str(grid_position.x)
		HUDs['grid_y_position'].text = str(grid_position.y)
	else:
		HUDs['grid_x_position'].text = '-'
		HUDs['grid_y_position'].text = '-'
	if typeof(real_position) == TYPE_VECTOR2:
		HUDs['real_x_position'].text = str(int(real_position.x))
		HUDs['real_y_position'].text = str(int(real_position.y))
	else:
		HUDs['grid_x_position'].text = '-'
		HUDs['grid_y_position'].text = '-'

func real2boardpos(pos, t_size):
	# For calling convienience - using Game's method  
	return get_node("/root/Game").real2boardpos(pos, t_size)

func board2realpos(bp, t_size):
	# For calling convienience - using Game's method  
	return get_node("/root/Game").board2realpos(bp, t_size)

func move_snapped(real_position : Vector2) -> void:
	# Note: `real_position` is not the final position of the cursor -
	#		 it will instead be snapped to the closest valid position
	#		 within the grid.
	# Use `move_freely` for an arbitrary destination.
	var bp = self.real2boardpos(real_position, movement_step)
	bp.y = max(0, min(bp.y, 7))
	bp.x = max(0, min(bp.x, 7))
	if real2boardpos(position, movement_step) != bp:
		position = board2realpos(bp, movement_step)
		update_on_hud_position(real_position, bp)

func move_freely(real_position : Vector2) -> void:
	# Moves the cursor to an arbitrary `real_postition` destination
	position = real_position
	update_on_hud_position(real_position, null)

func toggle_hud() -> void:
	$HUD.visible = !$HUD.visible

######################################################

func _process(_delta: float) -> void:
	move_snapped(get_global_mouse_position())
