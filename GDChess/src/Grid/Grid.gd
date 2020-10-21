extends Node2D


var tile_size : Vector2
var _scale : Vector2
var grid : Dictionary = {}



class AlternateTiles:
	
	var _white_tile : PackedScene
	var _black_tile : PackedScene
	var _white := false

	func _init():
		_white_tile = load("res://src/Tiles/WhiteTiles.tscn")
		_black_tile = load("res://src/Tiles/BlackTiles.tscn")
	
	func next():
		var ret
		if _white:
			ret = _white_tile
		else:
			ret = _black_tile
		_white = !_white
		return ret



func update_grid():
	var alt = AlternateTiles.new()
	var window_size = OS.get_window_size()
	var t = alt._white_tile.instance()
	var original_tile_size = t.get_size()
	
	original_tile_size.x = original_tile_size.x / 5
	t.queue_free()
	tile_size = Vector2(min(window_size.x, window_size.y) / 8.0, min(window_size.x, window_size.y) / 8.0)
	_scale = tile_size / original_tile_size
	for y in range(8):
		alt.next()
		for x in range(8):
			var tile
			if !(Vector2(x,y) in grid):
				tile = alt.next().instance()
				add_child(tile)
				tile.set_owner(self)
				grid[Vector2(x,y)] = tile.get_instance_id()
			else:
				tile = instance_from_id(grid[Vector2(x,y)])
			var pos = Vector2(x,y) * tile_size + tile_size / 2
			tile.set_scale(_scale)
			tile.global_position = pos


func _ready():
	update_grid()

func _on_Game_resized():
	update_grid()
