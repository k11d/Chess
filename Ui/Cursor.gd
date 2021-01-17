extends Area2D
class_name Cursor, "res://Images/cursor.png"


var movement_step setget set_movement_step


func set_movement_step(v):
	movement_step = v

func real2boardpos(pos, t_size):
	return get_parent().real2boardpos(pos, t_size)

func board2realpos(bp, t_size):
	return get_parent().board2realpos(bp, t_size)

func _process(delta: float) -> void:
	if position != get_global_mouse_position():
		var bp = real2boardpos(get_global_mouse_position(), movement_step)
		bp.x = max(0, min(bp.x, 7))
		bp.y = max(0, min(bp.y, 7))
		position = board2realpos(bp, movement_step)

