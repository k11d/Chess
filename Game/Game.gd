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
#var turn_state : Global.TurnState
var marker_scene : PackedScene = load("res://Ui/Marker.tscn")


const _start_positions := [
	"rnbkqbnr",
	"pppppppp",
	"00000000",	
	"00000000",	
	"00000000",	
	"00000000",	
	"PPPPPPPP",
	"RNBKQBNR"
]


func _ready() -> void:
	cursor = get_node("Cursor")
	cursor.disabled = false
	cursor.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor.set_movement_step(tile_size)
	
	white_player = get_node("WhitePlayer")
	black_player = get_node("BlackPlayer")
	
	board = get_node("Board")
	board.create_grid(tiles)
#	turn_state = Global.TurnState.new()
	Global.register_game_state(init_pieces(_start_positions))
	


func init_pieces(grid : Array) -> Dictionary:
	var pos : Vector2
	var new_grid := {}
	for y in range(8):
		for x in range(8):
			pos = Vector2(x, y)
			var c = grid[y][x]
			var piece = null
			match c:
				"r":
					piece = preload("res://Pieces/nodes/Rook.tscn").instance()
					piece.piece_color = "Black"
				"n":
					piece = preload("res://Pieces/nodes/Knight.tscn").instance()
					piece.piece_color = "Black"
				"b":
					piece = preload("res://Pieces/nodes/Bishop.tscn").instance()
					piece.piece_color = "Black"
				"k":
					piece = preload("res://Pieces/nodes/King.tscn").instance()
					piece.piece_color = "Black"
				"q":
					piece = preload("res://Pieces/nodes/Queen.tscn").instance()
					piece.piece_color = "Black"
				"p":
					piece = preload("res://Pieces/nodes/Pawn.tscn").instance()
					piece.piece_color = "Black"
				"R":
					piece = preload("res://Pieces/nodes/Rook.tscn").instance()
					piece.piece_color = "White"
				"N":
					piece = preload("res://Pieces/nodes/Knight.tscn").instance()
					piece.piece_color = "White"
				"B":
					piece = preload("res://Pieces/nodes/Bishop.tscn").instance()
					piece.piece_color = "White"
				"K":
					piece = preload("res://Pieces/nodes/King.tscn").instance()
					piece.piece_color = "White"
				"Q":
					piece = preload("res://Pieces/nodes/Queen.tscn").instance()
					piece.piece_color = "White"
				"P":
					piece = preload("res://Pieces/nodes/Pawn.tscn").instance()
					piece.piece_color = "White"
				_:
					piece = null
			new_grid[pos] = piece
			if piece == null:
				continue
			else:
				piece.grid_position = pos
				piece.global_position = board2realpos(pos, tile_size)
				if piece.piece_color == "White":
					piece.modulate = white_mod_color
					piece.set_owner(white_player)
					white_player.add_child(piece)
				else:
					piece.modulate = black_mod_color				
					piece.set_owner(black_player)
					black_player.add_child(piece)
	return new_grid


func move_piece(piece, target_real, speed_factor=0.5) -> void:
	var t = Tween.new()
	piece.add_child(t)
	piece.grid_position = real2boardpos(target_real)
	if piece.has_method("set_moved"):
		piece.set_moved()
	t.interpolate_property(piece, "global_position",
		piece.global_position, target_real, speed_factor,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Global.update_piece_position(piece)
	t.start()

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
	for p in white_player.get_children() + black_player.get_children():
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
			clear_highlights()
			if area.has_method('get_available_moves'):
				var tp = area.get_available_moves()
				if tp:
					if typeof(tp) == TYPE_ARRAY:
						for tgt in tp:
							highlight_position(tgt, Global.TargetedPositions.MarkerColor.Blue)
					elif tp.has_method("highlight_position"):
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
	if event.is_action_pressed("toggle_HUD"):
		cursor.toggle_hud()
	if event.is_action_pressed("select_piece"):
		cursor.selected_piece = cursor.hovering_piece

