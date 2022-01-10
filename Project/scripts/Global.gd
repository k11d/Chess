extends Node

const _board_brick_size := Vector2(128, 128)

var white_pieces : Array
var black_pieces : Array
var board_state : Dictionary


func _ready() -> void:
    for y in range(8):
        for x in range(8):
            board_state[Vector2(x,y)] = null


func init_board(whites : Array, blacks : Array) -> void:
    white_pieces = whites
    black_pieces = blacks
    for p in whites + blacks:
        board_state[p.grid_position] = p
        p.connect("piece_clicked", self, "on_piece_clicked")


func on_piece_clicked(piece) -> void:
    print("Clicked on: ", piece)


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
