extends Node2D
class_name Marker, "res://Images/light_green.png"


const _red_sprite := preload("res://Images/light_red.png")
const _blue_sprite := preload("res://Images/light_blue.png")
const _green_sprite := preload("res://Images/light_green.png")
export(Global.MarkerColor) var marker_color \
		= Global.MarkerColor.Blue setget set_marker_color


func set_marker_color(cname):
	marker_color = cname
	if $Sprite:
		match marker_color:
			Global.MarkerColor.Blue:
				$Sprite.texture = _blue_sprite
			Global.MarkerColor.Red:
				$Sprite.texture = _red_sprite
			Global.MarkerColor.Green:
				$Sprite.texture = _green_sprite


