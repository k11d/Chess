extends Node2D
class_name Tile


var tile_size := Vector2(128, 128)
enum TileMode {White, Black, Unset}
export(TileMode) var mode = TileMode.Unset setget set_mode


func _ready() -> void:
	tile_size = $White.get_rect().size

func set_black_mode():
	self.set_mode(TileMode.Black)
	
func set_white_mode():
	self.set_mode(TileMode.White)
	 

func set_mode(m):
	mode = m
	match mode:
		TileMode.Black:
			$Black.visible = true
			$White.visible = false
		TileMode.White:
			$Black.visible = false
			$White.visible = true
		_:
			$Black.visible = false
			$White.visible = false


