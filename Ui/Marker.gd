extends Node2D
class_name Marker, "res://Source/Images/light_green.png"


const _red_sprite := preload("res://Source/Images/light_red.png")
const _blue_sprite := preload("res://Source/Images/light_blue.png")
const _green_sprite := preload("res://Source/Images/light_green.png")
export(Global.TargetedPositions.MarkerColor) var marker_color \
		= Global.TargetedPositions.MarkerColor.Blue setget set_marker_color
onready var animation_player := $AnimationPlayer


func set_marker_color(cname):
	marker_color = cname
	if $Sprite:
		match marker_color:
			Global.TargetedPositions.MarkerColor.Blue:
				$Sprite.texture = _blue_sprite
			Global.TargetedPositions.MarkerColor.Red:
				$Sprite.texture = _red_sprite
			Global.TargetedPositions.MarkerColor.Green:
				$Sprite.texture = _green_sprite

func start_loop():
	$AnimationPlayer.play("Idle")
