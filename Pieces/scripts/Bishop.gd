extends ChessPiece
class_name Bishop, "res://Images/bishop.png"

func _ready():
	pname = "Bishop"


func get_available_moves():
	var allies = my_allies()
	var enemies = my_enemies()
	print("Allies:")
	print(allies)
	print("#######")
	print("Enemies:")
	print(enemies)

