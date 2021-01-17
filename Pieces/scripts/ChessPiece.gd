extends Area2D
class_name ChessPiece, "res://Images/bricks3.png"


export var self_modulate_color : Color setget set_self_modulate_color
var sprite : Sprite
var glow : Sprite
var anim_player : AnimationPlayer
var piece_color : String = "Unset"
var pname : String = "Unknown"
var pcolor : String = "Unknown" setget ,get_pcolor
var grid_position : Vector2
var glowing : bool = false
var available_moves : Array
var enemy_player : PlayerBase


func get_pcolor():
	if name.ends_with("B"):
		return "Black"
	else:
		return "White"


func set_self_modulate_color(col : Color):
	self_modulate_color = col
	if sprite:
		sprite.self_modulate = self_modulate_color


func _ready() -> void:
	sprite = $Sprite
	glow = $Glow
	anim_player = $AnimationPlayer
	if get_parent().name.begins_with("White"):
		piece_color = "White"
		enemy_player = get_node("/root/Game/BlackPlayer")
	else:
		piece_color = "Black"
		enemy_player = get_node("/root/Game/WhitePlayer")		
	if anim_player:
		anim_player.play("Phaser")	
		anim_player.seek(0.5, true)
		anim_player.stop()


func _process(delta):
	if glowing:
		if anim_player and !anim_player.is_playing():
			anim_player.play("Phaser")
	else:
		if anim_player and anim_player.is_playing():
			anim_player.seek(0.5, true)
			anim_player.stop()


func _to_string():
	var s : String = ""
	s += piece_color
	s += " "
	s += name
	s += " at " + str(global_position.x) + " " + str(global_position.y)
	return s


func my_allies():
	var allies : Array = get_parent().pieces
	allies.remove(allies.find(self)) # remove myself from allies array
	return allies


func my_enemies():
	return enemy_player.pieces


func moveUp():
	print("From:", grid_position, " to: ", get_parent().grid_positions[Vector2(grid_position.x, grid_position.y-1)])


func toggle_glow():
	glowing = !glowing


