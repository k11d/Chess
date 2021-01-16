extends PlayerBase
class_name BlackPlayer, "res://icon.png"



func _ready():
	player_color = "Black"
	for piece in get_children():
		pieces.append(piece)
	enemy = get_node("../WhitePlayer")
