tool
extends PlayerBase
class_name WhitePlayer, "res://icon.png"


func _ready():
	player_color = "White"
	for piece in get_children():
		pieces.append(piece)
	enemy = get_node("../BlackPlayer")
