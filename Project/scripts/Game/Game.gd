extends Node
class_name Game


func _ready() -> void:
    Global.init_board($Pieces/White.get_children(),
                      $Pieces/Black.get_children())
    
