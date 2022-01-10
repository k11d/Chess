extends Node2D
class_name Board, "res://assets/images/icon.png"

var monitoring_pieces : bool = true setget set_monitoring_pieces

#signal piece_entered_position(piece)

func set_monitoring_pieces(state : bool) -> void:
    monitoring_pieces = state
    for brick in get_children():
        brick.monitoring = state


#func _ready() -> void:
#    for brick in get_children():
#        brick.connect("area_entered", self, "on_piece_entered_brick")
#
#func on_piece_entered_brick(piece) -> void:
#    emit_signal("piece_entered_position", piece)
#

