extends Area2D
class_name Cursor, "res://Images/cursor.png"


var disabled : bool = false
var movement_step setget set_movement_step
var hovering_piece setget set_hovering_piece
onready var hud_position := $HUD/Position


func set_movement_step(v):
	movement_step = v

func set_hovering_piece(p):
	hovering_piece = p
	if hovering_piece:
		$HUD/Hovering.text = str(hovering_piece)
		$HUD/Hovering.visible = true
	else:
		$HUD/Hovering.text = ''
		$HUD/Hovering.visible = false

func real2boardpos(pos, t_size):
	return get_parent().real2boardpos(pos, t_size)

func board2realpos(bp, t_size):
	return get_parent().board2realpos(bp, t_size)

func _process(_delta: float) -> void:
	if position != get_global_mouse_position():
#		get_parent().clear_highlights()
		var bp = real2boardpos(get_global_mouse_position(), movement_step)
		bp.x = max(0, min(bp.x, 7))
		bp.y = max(0, min(bp.y, 7))
		position = board2realpos(bp, movement_step)
		hud_position.text = str(bp.x) + "," + str(bp.y)
