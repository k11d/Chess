extends Node2D


export(Color) var white_mod_color = Color.lightgray
export(Color) var black_mod_color = Color.violet
var screen
var tile_size := Vector2(128,128)
var board : Board
var tiles := {}      	 # grid positions -> instances
var white_player : Player
var black_player : Player
var cursor : Cursor = null
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
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    cursor.movement_step = tile_size
    
    white_player = get_node("WhitePlayer")
    black_player = get_node("BlackPlayer")
    
    board = get_node("Board")
    board.create_grid(tiles)
    init_pieces(_start_positions)
    Global.register_game_state(dict_game())
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

func dict_game_string() -> Dictionary:
    # Get a Dictionary representation of the board
    var d := {}
    for p in white_player.get_children():
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
    for p in black_player.get_children():
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
    for y in range(8):
        for x in range(8):
            var p = Vector2(x,y)
            if !(p in d):
                d[p] = '0'
    return d

func dict_game() -> Dictionary:
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
#    Global.update_piece_position(piece)
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
            remove_child(child)
            child.queue_free()

func _on_Cursor_area_entered(area) -> void:
    if !cursor.disabled:
        if turn_state.state == 'ToPick':
            clear_highlights()
        if area is ChessPiece:
            cursor.hovering_piece = area
            if turn_state.state == 'ToPick':
                var tp = area.get_available_moves()
                if tp:
                    area.toggle_glow_on()
                    if tp is Targets:
                        for i in range(len(tp.targets)):
                            highlight_position(tp.targets[i], tp.colors[i])
                    else:
                        for tgt in tp:
                            highlight_position(tgt, Color.cyan)

func _on_Cursor_area_exited(area) -> void:
    if !cursor.disabled:
        if area is ChessPiece:
            area.toggle_glow_off()
            cursor.hovering_piece = null
        if turn_state.state == "ToPick":
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
            cursor.selected_piece = cursor.hovering_piece
            if cursor.selected_piece:
                turn_state.player_picked()
                cursor.selected_piece.picked_at = cursor.selected_piece.global_position
                var m = cursor.selected_piece.get_available_moves()
                if m:
                     cursor.legal_target_positions = m.targets
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
