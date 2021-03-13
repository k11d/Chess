extends Node2D


export(Color) var white_mod_color = Color.lightgray
export(Color) var black_mod_color = Color.violet
var screen
var tile_size := Vector2(128,128)
var board : Board
var tiles := {}      	 # grid positions -> instances
var white_player : Player
var black_player : Player
export(NodePath) onready var cursor = get_node(cursor) as Cursor
export(NodePath) onready var hud = get_node(hud) as CanvasLayer
var turn_state : Global.TurnState
const marker_scene : PackedScene = preload("res://Ui/Marker.tscn")


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
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor.movement_step = tile_size
	
	white_player = get_node("WhitePlayer")
	black_player = get_node("BlackPlayer")
	
	board = get_node("Board")
	board.create_grid(tiles)
	init_pieces(_start_positions)
	Global.register_board_state(dict_board())
	hud.show_game_state(string_board())
	turn_state = Global.TurnState.new()
	cursor.disabled = false


func init_pieces(grid : Array):
	var pos : Vector2
	for y in range(8):
		for x in range(8):
			pos = Vector2(x, y)
			var c = grid[y][x]
			var piece = null
			match c:
				"r":
					piece = load("res://Pieces/nodes/Rook.tscn").instance()
					piece.piece_color = "Black"
				"n":
					piece = load("res://Pieces/nodes/Knight.tscn").instance()
					piece.piece_color = "Black"
				"b":
					piece = load("res://Pieces/nodes/Bishop.tscn").instance()
					piece.piece_color = "Black"
				"k":
					piece = load("res://Pieces/nodes/King.tscn").instance()
					piece.piece_color = "Black"
				"q":
					piece = load("res://Pieces/nodes/Queen.tscn").instance()
					piece.piece_color = "Black"
				"p":
					piece = load("res://Pieces/nodes/Pawn.tscn").instance()
					piece.piece_color = "Black"
				"R":
					piece = load("res://Pieces/nodes/Rook.tscn").instance()
					piece.piece_color = "White"
				"N":
					piece = load("res://Pieces/nodes/Knight.tscn").instance()
					piece.piece_color = "White"
				"B":
					piece = load("res://Pieces/nodes/Bishop.tscn").instance()
					piece.piece_color = "White"
				"K":
					piece = load("res://Pieces/nodes/King.tscn").instance()
					piece.piece_color = "White"
				"Q":
					piece = load("res://Pieces/nodes/Queen.tscn").instance()
					piece.piece_color = "White"
				"P":
					piece = load("res://Pieces/nodes/Pawn.tscn").instance()
					piece.piece_color = "White"
				_:
					piece = null
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


func string_rows_board() -> Array:
	# Get a string representation of the board (like _start_positions)
	# Example:
	# [RNBKQBNR, PPPPPPPP, 00000000, 00000000, 00000000, 00000p00, ppppp0pp, rnbkqbnr]
	var d := {}
	for p in white_player.get_children() + black_player.get_children():
		if p.piece_color == 'White':
			if "Pawn" in p.name:
				d[p.grid_position] = 'p'
			elif "Rook" in p.name:
				d[p.grid_position] = 'r'
			elif "Bishop" in p.name:
				d[p.grid_position] = 'b'
			elif "Knight" in p.name:
				d[p.grid_position] = 'n'
			elif "Queen" in p.name:
				d[p.grid_position] = 'q'
			elif "King" in p.name:
				d[p.grid_position] = 'k'
		else:
			if "Pawn" in p.name:
				d[p.grid_position] = 'P'
			elif "Rook" in p.name:
				d[p.grid_position] = 'R'
			elif "Bishop" in p.name:
				d[p.grid_position] = 'B'
			elif "Knight" in p.name:
				d[p.grid_position] = 'N'
			elif "Queen" in p.name:
				d[p.grid_position] = 'Q'
			elif "King" in p.name:
				d[p.grid_position] = 'K'
				
	var grid_state := []
	for y in range(8):
		var row := ""
		for x in range(8):
			var p = Vector2(x,y)
			if p in d:
				row += d[Vector2(x,y)]
			else:
				row += "0"
		grid_state.append(row)
	return grid_state

func string_board() -> String:
	var rows :Array = string_rows_board()
	var s := ""
	for row in rows:
		s += row + "\n"
	return s


func dict_board() -> Dictionary:
	# Get a Dictionary representation of the board
	var d := {}
	for p in white_player.get_children():
		d[p.grid_position] =p
	for p in black_player.get_children():
		d[p.grid_position] =p
	for y in range(8):
		for x in range(8):
			var p = Vector2(x,y)
			if !(p in d):
				d[p] = null
	return d


func move_piece(piece, target_real, speed_factor=0.5) -> void:
	var t = Tween.new()
	piece.add_child(t)
	piece.grid_position = real2boardpos(target_real)
	if piece.has_method("set_moved"):
		piece.set_moved()
	t.interpolate_property(piece, "global_position",
		piece.global_position, target_real, speed_factor,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
#	t.connect("tween_all_completed", self, "piece_done_moving")
	t.start()

#func piece_done_moving():
#	print("piece done moving")

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


func mark_available_moves(piece):
	var tp = piece.get_available_moves()
	if tp:
		piece.toggle_glow_on()
		if tp is Targets:
			for i in range(len(tp.targets)):
				highlight_position(tp.targets[i], tp.colors[i])
		else:
			for tgt in tp:
				highlight_position(tgt, Color.cyan)


func clear_highlights() -> void:
	for child in get_children():
		if child is Marker:
			remove_child(child)
			child.queue_free()


func _on_Cursor_area_entered(area) -> void:
	if !cursor.disabled:
		if area is ChessPiece:
			cursor.hovering_piece = area
#			if turn_state.state == 'ToPick':
#				clear_highlights()
#				if area is ChessPiece and turn_state.now_playing == area.piece_color and turn_state.state == 'ToPick':
#					mark_available_moves(area)


func _on_Cursor_area_exited(area) -> void:
	if !cursor.disabled:
		if area is ChessPiece:
			area.toggle_glow_off()
			cursor.hovering_piece = null


func pick_piece(piece):
#	if turn_state.now_playing == cursor.hovering_piece.piece_color:
	cursor.selected_piece = piece
	cursor.selected_piece.picked_at = cursor.selected_piece.global_position
	cursor.legal_target_positions = cursor.selected_piece.get_available_moves()
	turn_state.player_picked()
	mark_available_moves(cursor.selected_piece)


func validate_play(piece, target):
	var captured
	for p in Global.pieces():
		if p.grid_position == target:
			captured = p
			break
	if captured:
		print("Capturing :", captured)
		captured.queue_free()
	turn_state.player_played()
	clear_highlights()
	cursor.selected_piece.add_history(real2boardpos(cursor.selected_piece.picked_at))
	move_piece(cursor.selected_piece, board2realpos(target), 0.2)	
	if cursor.selected_piece.has_method("set_moved"):
		cursor.selected_piece.set_moved()
	Global.register_board_state(dict_board())
	hud.show_game_state(string_board())
	cursor.selected_piece = null


func cancel_play():
	turn_state.player_cancelled()
	clear_highlights()
	if cursor.selected_piece:
		var dest = cursor.selected_piece.picked_at
		move_piece(cursor.selected_piece, dest, 0.1)
		if cursor.selected_piece.has_method('set_moved'):
			if len(cursor.selected_piece.history) == 0:
				cursor.selected_piece.never_moved = true
		cursor.selected_piece = null
		cursor.legal_target_positions.clear()


func _input(event):
#	if event.is_action_pressed("DEBUG_randomize"):
#		randomize_game()
#	if event.is_action_pressed("toggle_HUD"):
#		hud.toggle_hud()

	var touch = event as InputEventScreenTouch
	if touch:
		if touch.pressed:
			print(touch.position)
			var previous_pos = real2boardpos(cursor.global_position)
			cursor.move_snapped(touch.position + tile_size / 2.0)
			var new_pos = real2boardpos(cursor.global_position)
			cursor.hovering_piece = Global.piece_at(new_pos)
			if new_pos == previous_pos:
				if turn_state.state == 'ToPick':
					if cursor.hovering_piece and cursor.hovering_piece.piece_color == turn_state.now_playing:
						cancel_play()
						pick_piece(cursor.hovering_piece)
				if turn_state.state == 'ToPlay':
					var cursor_target = new_pos
					if cursor_target in cursor.legal_target_positions.targets:
						validate_play(cursor.selected_piece, cursor_target)
					else:
						if cursor.hovering_piece and turn_state.now_playing == cursor.hovering_piece.piece_color:
							cancel_play()
							pick_piece(cursor.hovering_piece)
