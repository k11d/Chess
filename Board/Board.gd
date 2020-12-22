extends Node2D

var _tile = preload("res://Board/Tile.tscn")
var tile_size := Vector2(126, 126)

func create_grid(tiles, grid_positions):
	var gp
	var _last_col = 0
	for y in range(8):
		for x in range(8):
			var tile = _tile.instance()
			if _last_col % 2 == 0:
				tile.set_white_mode()
			else:
				tile.set_black_mode()
			_last_col += 1
			tile.set_position_label_text(str(x) + ':' + str(y))
			gp = Vector2(x,y)
			tiles[gp] = tile
			tile.position = gp * tile_size + 0.5 * tile_size
			grid_positions[gp] = tile.position
			add_child(tile)
		_last_col += 1
