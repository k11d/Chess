extends Node2D


export(Color) var white_mod_color = Color.lightgray
export(Color) var black_mod_color = Color.violet
var tile_size := Vector2(128,128)
var board
var grid_positions := {} # grid_positions -> real positions 
var tiles := {}      	 # grid positions -> instances
var white_player : WhitePlayer = null
var black_player : BlackPlayer = null
var cursor : Cursor = null



func _ready() -> void:
	board = get_node("Board")
	cursor = get_node("Cursor")
	white_player = get_node("WhitePlayer")
	black_player = get_node("BlackPlayer")
	board.create_grid(tiles, grid_positions)
	init_pieces()
	randomized_loc_show_in()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor.set_movement_step(tile_size)
	cursor.set_white_player_color(white_mod_color)
	cursor.set_black_player_color(black_mod_color)
	cursor.visible = true


func init_pieces():
	set_pieces_mod_color(white_player.pieces, white_mod_color)
	set_pieces_mod_color(black_player.pieces, black_mod_color)
	set_pieces_board_positions(white_player.pieces + black_player.pieces)	


func set_pieces_mod_color(pieces, color):
	for piece in pieces:
		piece.modulate = color

func set_pieces_board_positions(pieces):
	for piece in pieces:
		piece.grid_position = real2boardpos(piece.global_position, tile_size)
		piece.global_position = grid_positions[piece.grid_position]
		print(piece.pname, " has been set at ", piece.grid_position)


func randomized_loc_show_in():
	if white_player and black_player:
		var screen = OS.get_window_size()
		for piece in white_player.pieces + black_player.pieces:
			var target_position = piece.global_position
			piece.global_position = Vector2(rand_range(-620.0, screen.x), rand_range(0.0, screen.y))
			var t = Tween.new()
			piece.add_child(t)
			t.interpolate_property(piece, "global_position",
				piece.global_position, target_position, 0.4,
				Tween.TRANS_LINEAR, Tween.EASE_IN)
			t.start()



func real2boardpos(real_pos: Vector2, tile_size) -> Vector2:
	var p = (real_pos - 0.5 * tile_size) / tile_size	
	p.x = floor(p.x)
	p.y = floor(p.y)
	return p

func _on_Cursor_area_entered(area):
	if area.has_method('toggle_glow'):
		area.toggle_glow()

func _on_Cursor_area_exited(area):
	if area.has_method('toggle_glow'):
		area.toggle_glow()
