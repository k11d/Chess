tool
extends Node2D
class_name Marker, "res://Images/light_green.png"

var _red_sprite := "res://Images/light_red.png"
var _blue_sprite := "res://Images/light_blue.png"
var _green_sprite := "res://Images/light_green.png"
enum MarkerColor {Red, Green, Blue}
export(MarkerColor) var marker_color = MarkerColor.Blue setget set_marker_color


func set_marker_color(cname):
	marker_color = cname
	match marker_color:
		MarkerColor.Blue:
			update_sprite_texture(_blue_sprite)
		MarkerColor.Red:
			update_sprite_texture(_red_sprite)
		MarkerColor.Green:
			update_sprite_texture(_green_sprite)


func update_sprite_texture(texture_path):
	if $Sprite:
		var im = Image.new()
		im.load(texture_path)
		var t = ImageTexture.new()
		t.create_from_image(im)
		$Sprite.texture = t
