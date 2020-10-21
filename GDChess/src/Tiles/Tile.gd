extends Sprite
class_name Tile

export(int, 0, 4, 1) var tile_id = 0 setget _set_tile_id

func _init():
	random_tile_id()

func _set_tile_id(id):
	tile_id = id
	frame = tile_id

func get_size():
	return texture.get_size()

func random_tile_id():
	_set_tile_id(randi() % 5)
