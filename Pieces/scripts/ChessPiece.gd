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
var targeted : Global.TargetedPositions
var enemy_player


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
	targeted = Global.TargetedPositions.new()

func _to_string() -> String:
	var s : String = ""
	s += piece_color
	s += " "
	s += name
	s += " at " + str(global_position.x) + " " + str(global_position.y)
	s += " (" + str(grid_position.x) + " " + str(grid_position.y) + ") "
	return s

func my_allies() -> Array:
	var allies : Array = get_parent().get_children()
	allies.remove(allies.find(self)) # remove myself from allies array
	return allies

func my_enemies() -> Array:
	if name.ends_with("B"):
		return get_node('/root/Game/WhitePlayer').get_children()
	else:
		return get_node('/root/Game/BlackPlayer').get_children()

func pieces_grid_positions(pieces) -> Array:
	var pgp := []
	for p in pieces:
		pgp.append(p.grid_position)
	return pgp

func toggle_glow() -> void:
	glowing = !glowing

func filter_out_of_grid(positions) -> Array:
	var filtered := []
	for pos in positions:
		if pos.x < 0 or pos.y < 0 or pos.x > 7 or pos.y > 7:
			continue
		else:
			filtered.append(pos)
	return filtered


#########################################################

func _process(delta) -> void:
	if glowing:
		if anim_player and !anim_player.is_playing():
			anim_player.play("Phaser")
	else:
		if anim_player and anim_player.is_playing():
			anim_player.seek(0.5, true)
			anim_player.stop()


