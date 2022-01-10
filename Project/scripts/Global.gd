extends Node

const _board_brick_size := Vector2(128, 128)
const _highlight_custom := preload("res://scenes/HUD/Highlight/HLCustom.tscn")

enum GameState {
    WhiteToPick,
    WhiteToPlay,
    BlackToPick,
    BlackToPlay
}

var game : Game
var game_state setget set_game_state
var white_pieces : Array
var black_pieces : Array
var current_player_pieces : Array
var current_opponent_pieces : Array

var current_highlights : Array
var current_selected_piece : ChessPiece
var current_selected_piece_targets : Targets


func _ready() -> void:
    current_highlights = []
    current_selected_piece = null
    self.game_state = GameState.WhiteToPick


func set_game_state(gstate) -> void:
    game_state = gstate
#    print("Game state : ", GameState.keys()[gstate])
    if gstate == GameState.WhiteToPick or gstate == GameState.WhiteToPlay:
        current_player_pieces = white_pieces
        current_opponent_pieces = black_pieces
    elif gstate == GameState.BlackToPick or gstate == GameState.BlackToPlay:
        current_player_pieces = black_pieces
        current_opponent_pieces = white_pieces


func init_board(game_node : Game, whites : Array, blacks : Array) -> void:
    game = game_node
    white_pieces = whites
    black_pieces = blacks
    for p in whites + blacks:
        p.connect("piece_clicked", self, "on_piece_clicked")


func clear_highlights() -> void:
    for hl in current_highlights:
        hl.queue_free()
    current_highlights.clear()
            

func on_piece_clicked(piece) -> void:
    # Make sure not trying to pick opponents piece.
    if game_state == GameState.WhiteToPick and piece.piece_color == "Black":
        return
    if game_state == GameState.BlackToPick and piece.piece_color == "White":
        return
    if game_state == GameState.WhiteToPlay and piece.piece_color == "Black":
        return
    if game_state == GameState.BlackToPlay and piece.piece_color == "White":
        return
    else:
        if game_state == GameState.WhiteToPlay and piece.piece_color == "White":
            #selected second white piece
            pass
        elif game_state == GameState.BlackToPlay and piece.piece_color == "Black":
            #selected second black piece
            pass
            
        elif game_state == GameState.WhiteToPick:
            self.game_state = GameState.WhiteToPlay
        elif game_state == GameState.BlackToPick:
            self.game_state = GameState.BlackToPlay
        current_selected_piece = piece
        clear_highlights()        
        var targets : Targets = piece.get_available_moves()
        current_selected_piece_targets = targets            
        for tid in targets.count:
            var hl = _highlight_custom.instance()
            game.add_child(hl)
            hl.connect("highlight_clicked", self, "on_highlight_clicked")
            hl.hl_color = targets.colors[tid]
            hl.hl_grid_position = targets.targets[tid]
            hl.position = targets.targets[tid] * _board_brick_size + 0.5 * _board_brick_size
            current_highlights.append(hl)


func on_highlight_clicked(hl : Highlight) -> void:    
    var tinfo = current_selected_piece_targets.get_target_info(hl.hl_grid_position)
    var dest_target = tinfo[0]
    var capture_flag = tinfo[1]
    if capture_flag:
        var captured_piece 
        for p in current_opponent_pieces:
            if p.grid_position == dest_target:
                captured_piece = p
                break
        print("Captured piece: ", captured_piece)
        captured_piece.hide()
        current_opponent_pieces.erase(captured_piece)
        captured_piece.free()
        
    print("Moved: ", current_selected_piece, " to ", dest_target)
    current_selected_piece.grid_position = dest_target
    current_selected_piece.position = hl.position
    if current_selected_piece.has_method("set_moved"):
        current_selected_piece.set_moved()
    current_selected_piece = null
    current_selected_piece_targets = null
    
    if game_state == GameState.WhiteToPlay:
        self.game_state = GameState.BlackToPick
    elif game_state == GameState.BlackToPlay:
        self.game_state = GameState.WhiteToPick
    clear_highlights()


func piece_positions(pcolor) -> Array:
    var positions := []
    var pieces
    if pcolor == "White":
        pieces = white_pieces
    elif pcolor == "Black":
        pieces = black_pieces
    for p in pieces:
        positions.append(p.grid_position)
    return positions
