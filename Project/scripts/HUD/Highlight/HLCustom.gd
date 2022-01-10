extends Highlight
class_name HLCustom


export(Color) var hl_color := Color.white setget set_hl_color


func set_hl_color(color) -> void:
    hl_color = color
    $Sprite.modulate = color

