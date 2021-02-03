extends Node2D
class_name Marker, "res://Images/light.png"

var color setget set_color 


func start_loop():
    $AnimationPlayer.play("Idle")

func set_color(col):
    color = col
    $Sprite.self_modulate = color
    $Sprite.self_modulate.a = 0.6
