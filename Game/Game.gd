extends Node2D


export(Color) var white_mod_color = Color.lightgray
export(Color) var black_mod_color = Color.violet
var screen
var tile_size := Vector2(128,128)
var board : Board
var tiles := {}      	 # grid positions -> instances
var white_player : Node2D
var black_player : Node2D
var _moving_pieces : Array = []
var cursor : Cursor = null
var turn_state : Global.TurnState
var marker_scene : PackedScene = preload("res://Ui/Marker.tscn")


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
	cursor.disabled = true
	cursor.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor.set_movement_step(tile_size)
	
	white_player = get_node("WhitePlayer")
	black_player = get_node("BlackPlayer")
	
	board = get_node("Board")
	board.create_grid(tiles)
	Global.register_game_state(init_pieces(_start_positions))
	turn_state = Global.TurnState.new()
	cursor.disabled = false


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
					white_player.add_child(piece)
				else:
					piece.modulate = black_mod_color				
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

func randomize_game() -> void:
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
	m.color = col
	m.scale = tile_size / m.get_child(0).get_rect().size
	m.position = board2realpos(pos)
	m.start_loop()
	add_child(m)

func clear_highlights() -> void:
	for child in get_children():
		if child is Marker:
			board.remove_child(child)
			child.queue_free()

func _on_Cursor_area_entered(area) -> void:
	if !cursor.disabled:
		if area is ChessPiece:
			cursor.hovering_piece = area
			area.toggle_glow()
			if turn_state.state == 'ToPick':
				var tp = area.get_available_moves()
				if tp and typeof(tp) == TYPE_ARRAY:
					for tgt in tp:
						highlight_position(tgt, Color.cyan)

func _on_Cursor_area_exited(area) -> void:
	if !cursor.disabled:
		if area is ChessPiece:
			area.toggle_glow()
			cursor.hovering_piece = null
			if turn_state.state == 'ToPick':
				clear_highlights()

func cancel_play():
	turn_state.player_cancelled()
	if cursor.selected_piece:
		var dest = cursor.selected_piece.picked_at
		move_piece(cursor.selected_piece, dest, 0.1)
		if cursor.selected_piece.has_method('set_moved'):
			if len(cursor.selected_piece.history) == 0:
				cursor.selected_piece.never_moved = true
		cursor.selected_piece = null
		cursor.legal_target_positions.clear()
		

func _input(event):
	if event.is_action_pressed("DEBUG_randomize"):
		randomize_game()
	if event.is_action_pressed("toggle_HUD"):
		cursor.toggle_hud()
	if event.is_action_pressed("cancel_picked_piece"):
		cancel_play()

	if event.is_action_pressed("pick_piece"):
		if turn_state.state == 'ToPick':
			turn_state.player_picked()
			cursor.selected_piece = cursor.hovering_piece
			cursor.selected_piece.picked_at = cursor.selected_piece.global_position
			cursor.legal_target_positions = cursor.selected_piece.get_available_moves()
			print("Legal moves:", cursor.legal_target_positions)
		
		elif turn_state.state == 'ToPlay':
			var target = real2boardpos(cursor.global_position)
			if target in cursor.legal_target_positions:
				clear_highlights()
				turn_state.player_played()
			
				var enemies
				if turn_state.now_playing == "White":
					enemies = Global.pieces("Black")
				else:
					enemies = Global.pieces("White")
				var captured_enemy = null
				for pce in enemies:
					if pce.grid_position == target:
						captured_enemy = pce
						break
				if captured_enemy:
					captured_enemy.queue_free()
				cursor.selected_piece.add_history(real2boardpos(cursor.selected_piece.picked_at))
				cursor.selected_piece.global_position = cursor.global_position
				cursor.selected_piece.grid_position = target
				if cursor.selected_piece.has_method("set_moved"):
					cursor.selected_piece.set_moved()
				Global.update_piece_position(cursor.selected_piece)
				cursor.selected_piece = null
			else:
				cancel_play()
