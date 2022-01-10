extends Area2D
class_name Highlight

var hl_grid_position : Vector2

signal highlight_clicked(me)


func set_hl_grid_position(pos) -> void:
    hl_grid_position = pos


func _on_Highlight_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:   
            emit_signal("highlight_clicked", self)
