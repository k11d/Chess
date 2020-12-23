extends Node2D
class_name Tile


var tile_size := Vector2(128, 128)
var white : Sprite
var black : Sprite
var position_label
enum TileMode {White, Black, Unset}
export(TileMode) var mode = TileMode.Unset setget set_mode


func _ready() -> void:
	tile_size = white.get_rect().size
	position_label = $PositionLabel

func set_black_mode():
	self.set_mode(TileMode.Black)
	
func set_white_mode():
	self.set_mode(TileMode.White)
	 

func set_mode(m):
	mode = m
	if !black:
		black = $Black
	if !white:
		white = $White
	match mode:
		TileMode.Black:
			black.visible = true
			white.visible = false
		TileMode.White:
			black.visible = false
			white.visible = true
		_:
			black.visible = false
			white.visible = false

func set_position_label_text(s):
	if !position_label:
		position_label = $PositionLabel
	position_label.text = s

func _on_Tile_mouse_entered() -> void:
	var gp = get_parent().closest_tile(get_global_mouse_position())
	print("mouse entered position: ", gp)

func _on_Tile_mouse_exited() -> void:
	var gp = get_parent().closest_tile(get_global_mouse_position())
	print("mouse exited position: ", gp)
