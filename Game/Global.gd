extends Node2D

var game_state : Dictionary 


func register_game_state(gm : Dictionary) -> void:
    game_state = gm

func update_piece_position(piece):
    game_state[piece.grid_position] = piece

func pieces(only_color=null) -> Array:
    var pcs := []
    for p in game_state.values():
        if p and only_color == null or p and only_color == p.piece_color:
            pcs.append(p)
    return pcs

func piece_positions(only_color=null) -> Array:
    var positions := []
    for pos in game_state:
        if only_color == null or game_state[pos] and only_color == game_state[pos].piece_color:
            positions.append(pos)
    return positions



class TurnState:
    
    var now_playing
    var state
    
    func _init():
        now_playing = "White"
        state = "ToPick"
    
    func _to_string() -> String:
        return now_playing + ' ' + str(state)
        
    func player_picked() -> void:
        state = 'ToPlay'
    
    func player_cancelled() -> void:
        state = 'ToPick'

    func player_played() -> void:
        match now_playing:
            'White':
                now_playing = 'Black'
            'Black':
                now_playing = 'White'
        state = "ToPick"

