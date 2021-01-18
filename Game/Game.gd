extends Node2D


export(Color) var white_mod_color = Color.lightgray
export(Color) var black_mod_color = Color.violet
var screen
var tile_size := Vector2(128,128)
var board
var grid_positions := {} # grid_positions -> real positions 
var tiles := {}      	 # grid positions -> instances
var white_player : WhitePlayer = null
var black_player : BlackPlayer = null
var cursor : Cursor = null
var turn_state : Global.TurnState
var marker_scene : PackedScene = load("res://Ui/Marker.tscn")


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
	cursor.visible = true
	turn_state = TurnState.new()
	print("Now playing; ", turn_state.now_playing)
#	test_markers()	
	

func init_pieces() -> void:
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


func randomized_loc_show_in() -> void:
	if white_player and black_player:
		screen = OS.get_window_size()
		for piece in white_player.pieces + black_player.pieces:
			var target_position = piece.global_position
			piece.global_position = Vector2(rand_range(-620.0, screen.x), rand_range(0.0, screen.y))
			move_piece(piece, target_position)


func move_piece(piece, target) -> void:
	var t = Tween.new()
	piece.add_child(t)
	t.interpolate_property(piece, "global_position",
		piece.global_position, target, 0.8,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	t.start()


func real2boardpos(real_pos: Vector2, tile_size) -> Vector2:
	var p = (real_pos - 0.5 * tile_size) / tile_size	
	p.x = floor(p.x)
	p.y = floor(p.y)
	return p

func board2realpos(bp, t_size) -> Vector2:
	return bp * t_size + t_size / 2


func test_markers():
	for t in board.get_children():
		highlight_position(t, Global.MarkerColor.Blue)


func highlight_position(parent, col) -> void:
	var m = marker_scene.instance()
	m.set_marker_color(col)
	parent.add_child(m)


func _on_Cursor_area_entered(area) -> void:
	if area is ChessPiece:
		cursor.hovering_piece = area
		area.toggle_glow()
		if area.has_method('get_available_moves'):
			var tp = area.get_available_moves()
			if tp:
				print(tp)
				for tpos in tiles:
					for child in tiles[tpos].get_children():
						if child is Marker:
							tiles[tpos].remove_child(child)
							child.free()
				for tgt in tp.get_all():
					highlight_position(tiles[tgt], 0)


func _on_Cursor_area_exited(area) -> void:
	if area is ChessPiece:
		cursor.hovering_piece = null
		area.toggle_glow()
