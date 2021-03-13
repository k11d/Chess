extends Area2D
class_name ChessPiece, "res://Images/bricks3.png"

const _targets_wrapper = preload("res://Game/Targets.gd")
export var self_modulate_color : Color setget set_self_modulate_color

export(NodePath) onready var sprite = get_node(sprite) as Sprite
export(NodePath) onready var glow = get_node(glow) as Sprite
export(NodePath) onready var anim_player = get_node(anim_player) as AnimationPlayer


var grid_position : Vector2
var glowing : bool = false
var enemy_player : Node
var piece_color : String
var picked_at : Vector2
var history : Array


func set_self_modulate_color(col : Color):
	self_modulate_color = col
	if sprite:
		sprite.self_modulate = self_modulate_color

func _ready() -> void:
	history = []
	if get_parent().name.begins_with("White"):
		enemy_player = get_node("/root/Game/BlackPlayer")
	else:
		enemy_player = get_node("/root/Game/WhitePlayer")
	if anim_player:
		anim_player.play("Phaser")	
		anim_player.seek(0.5, true)
		anim_player.stop()

func _to_string() -> String:
	var s : String = ""
	s += name
	s += " at " + str(global_position.x) + " " + str(global_position.y)
	s += " (" + str(grid_position.x) + " " + str(grid_position.y) + ") "
	return s

func toggle_glow_on() -> void:
	glowing = true

func toggle_glow_off() -> void:
	glowing = false

func add_history(pos : Vector2) -> void:
	history.append(pos)



#########################################################


func _process(_delta) -> void:
	if glowing:
		if anim_player and !anim_player.is_playing():
			anim_player.play("Phaser")
	else:
		if anim_player and anim_player.is_playing():
			anim_player.seek(0.5, true)
			anim_player.stop()
