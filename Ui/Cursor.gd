extends Area2D
class_name Cursor, "res://Images/cursor.png"


var movement_step setget set_movement_step
var white_player_color setget set_white_player_color
var black_player_color setget set_black_player_color
var now_playing = null


func set_movement_step(v):
	movement_step = v

func set_black_player_color(col):
	black_player_color = col

func set_white_player_color(col):
	white_player_color = col	


func real2boardpos(pos, t_size):
	return get_parent().real2boardpos(pos, t_size)

func board2realpos(bp, t_size):
	var p = bp * t_size + t_size / 2
	return p


func _ready() -> void:
	visible = false
	now_playing = get_node("../WhitePlayer")
	print("Now playing; ", now_playing)
	
func _process(delta: float) -> void:
	if position != get_global_mouse_position():
		position = board2realpos(real2boardpos(get_global_mouse_position(), movement_step), movement_step)
