extends Area2D
class_name ChessPiece, "res://Images/bricks3.png"


export var self_modulate_color : Color setget set_self_modulate_color
var sprite : Sprite
var glow : Sprite
var anim_player : AnimationPlayer
var grid_position : Vector2
var glowing : bool = false
var enemy_player : Node2D
var piece_color : String
var picked_at : Vector2
var history : Array


func set_self_modulate_color(col : Color):
	self_modulate_color = col
	if sprite:
		sprite.self_modulate = self_modulate_color

func _ready() -> void:
	sprite = $Sprite
	glow = $Glow
	anim_player = $AnimationPlayer
	history = []
	if get_parent().name.begins_with("White"):
		enemy_player = get_node("/root/Game/BlackPlayer")
	else:
		enemy_player = get_node("/root/Game/WhitePlayer")		
	if anim_player:
		anim_player.play("Phaser")	
		anim_player.seek(0.5, true)
		anim_player.stop()
#	targeted = Global.TargetedPositions.new()

func _to_string() -> String:
	var s : String = ""
	s += name
	s += " at " + str(global_position.x) + " " + str(global_position.y)
	s += " (" + str(grid_position.x) + " " + str(grid_position.y) + ") "
	return s

func toggle_glow() -> void:
	glowing = !glowing

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
