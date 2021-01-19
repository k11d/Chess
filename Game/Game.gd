extends Node2D


export(Color) var white_mod_color = Color.lightgray
export(Color) var black_mod_color = Color.violet
var screen
var tile_size := Vector2(128,128)
var board
var tiles := {}      	 # grid positions -> instances
var white_player : WhitePlayer = null
var black_player : BlackPlayer = null
var _moving_pieces : Array = []
var cursor : Cursor = null
var turn_state : Global.TurnState
var marker_scene : PackedScene = load("res://Ui/Marker.tscn")


func _ready() -> void:
	board = get_node("Board")
	cursor = get_node("Cursor")
	cursor.disabled = true
	white_player = get_node("WhitePlayer")
	black_player = get_node("BlackPlayer")
	board.create_grid(tiles)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor.set_movement_step(tile_size)
	cursor.visible = true
	turn_state = Global.TurnState.new()
	init_pieces()
	cursor.disabled = false


func init_pieces() -> void:
	set_pieces_mod_color(white_player.get_children(), white_mod_color)
	set_pieces_mod_color(black_player.get_children(), black_mod_color)
	set_pieces_board_positions(white_player.get_children() + black_player.get_children())

func set_pieces_mod_color(pieces, color):
	for piece in pieces:
		piece.modulate = color

func set_pieces_board_positions(pieces):
	for piece in pieces:
		piece.grid_position = real2boardpos(piece.global_position, tile_size)
		piece.global_position = board2realpos(piece.grid_position, tile_size)

func move_piece(piece, target_real, speed_factor=0.5) -> void:
	var t = Tween.new()
	piece.add_child(t)
	piece.grid_position = real2boardpos(target_real)
	t.interpolate_property(piece, "global_position",
		piece.global_position, target_real, speed_factor,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
#	t.connect("tween_completed", self, "register_piece_done_moving", [piece])
	t.start()

#func register_piece_moving(piece : ChessPiece) -> void:
#	_moving_pieces.append(piece)	
#
#func register_piece_done_moving(p : Array) -> void:
#	_moving_pieces.remove(_moving_pieces.find(p[0]))
#	if len(_moving_pieces) == 0:
#		cursor.disabled = false

func real2boardpos(real_pos: Vector2, t_size=null) -> Vector2:
	if t_size == null:
		t_size = tile_size
	var p = (real_pos - 0.5 * t_size) / t_size	
	p.x = floor(p.x)
	p.y = floor(p.y)
	return p

func board2realpos(bp, t_size=null) -> Vector2:
	if t_size == null:
		t_size = tile_size
	return bp * t_size + t_size / 2

func randomize_game():
	var available := []
	for tpos in tiles:
		available.append(tpos)
	clear_highlights()
	var dest : Vector2
	for p in white_player.pieces + black_player.pieces:
		dest = available[randi() % len(available) - 1]
		available.remove(available.find(dest))
		move_piece(p, board2realpos(dest, tile_size))

func highlight_position(pos, col) -> void:
	var m = marker_scene.instance()
	m.set_marker_color(col)
	m.start_loop()
	board.add_child(m)
	m.global_position = board2realpos(pos)


func clear_highlights():
	for child in board.get_children():
		if child is Marker:
			board.remove_child(child)
			child.queue_free()

func _on_Cursor_area_entered(area) -> void:
	if !cursor.disabled:
		if area is ChessPiece:
			cursor.hovering_piece = area
			area.toggle_glow()
			if area.has_method('get_available_moves'):
				var tp = area.get_available_moves()
				if tp:
					for tgt in tp.get_all():
						highlight_position(tgt, Global.TargetedPositions.MarkerColor.Blue)

func _on_Cursor_area_exited(area) -> void:
	if !cursor.disabled:
		if area is ChessPiece:
			clear_highlights()
			cursor.hovering_piece = null
			area.toggle_glow()


func _input(event):
	if event.is_action_pressed("DEBUG_randomize"):
		randomize_game()
