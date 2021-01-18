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
	cursor.disabled = true
	white_player = get_node("WhitePlayer")
	black_player = get_node("BlackPlayer")
	board.create_grid(tiles, grid_positions)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor.set_movement_step(tile_size)
	cursor.visible = true
	turn_state = Global.TurnState.new()
	print("Now playing; ", turn_state.now_playing)
	init_pieces()
	cursor.disabled = false
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
		piece.global_position = board2realpos(piece.grid_position, tile_size)


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


#func test_markers():
#	for t in board.get_children():
#		highlight_position(t, Global.MarkerColor.Blue)


func highlight_position(parent, col) -> void:
	var m = marker_scene.instance()
	m.set_marker_color(col)
	m.start_loop()
	parent.add_child(m)


func clear_highlights():
	for tpos in tiles:
		for child in tiles[tpos].get_children():
			if child is Marker:
				tiles[tpos].remove_child(child)
				child.free()


func _on_Cursor_area_entered(area) -> void:
	if !cursor.disabled:
		if area is ChessPiece:
			cursor.hovering_piece = area
			area.toggle_glow()
			if area.has_method('get_available_moves'):
				var tp = area.get_available_moves()
				if tp:
					clear_highlights()
					for tgt in tp.get_all():
						highlight_position(tiles[tgt], 0)


func _on_Cursor_area_exited(area) -> void:
	if !cursor.disabled:
		if area is ChessPiece:
			cursor.hovering_piece = null
			area.toggle_glow()


#func _input(event):
#	if event.is_action_pressed("select_piece"):
#
