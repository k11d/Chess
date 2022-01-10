extends Area2D
class_name ChessPiece

const _targets_wrapper := preload("res://scripts/Targets.gd")

var piece_name : String
var piece_color : String

signal piece_clicked(me)


func _ready() -> void:
    piece_name = self.name
    while piece_name[piece_name.length() - 1].is_valid_integer():
        piece_name.erase(piece_name.length() - 1, 1)
    piece_color = get_parent().name

func _to_string() -> String:
    return piece_color + " " + piece_name + " at: " + str(self.grid_position) 


func _on_ChessPiece_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            emit_signal("piece_clicked", self)


func my_allies() -> Array:
    var pieces : Array = get_parent().get_children()
    pieces.erase(self)
    return pieces


func my_enemies() -> Array:
    var my_parent = get_parent()
    var pieces_container = my_parent.get_parent()
    if pieces_container.get_child(0) is my_parent:
        return pieces_container.get_child(1).get_children()
    else:
        return pieces_container.get_child(0).get_children()


