extends Node2D
class_name Marker, "res://Images/light.png"

var color setget set_color 


func start_loop():
	$AnimationPlayer.play("Idle")

func set_color(col):
	color = col
	$Sprite.modulate = color
