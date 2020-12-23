extends Area2D
class_name Cursor, "res://Images/cursor.png"


var movement_step setget set_movement_step
var white_player_color 
var black_player_color
var now_playing = null
var tween := Tween.new()
var _moving := false
var captured_cursor := false
var hovering : ChessPiece = null setget set_hovering
var selected : ChessPiece = null setget set_selected
var selected_parent = null

func _ready() -> void:
	visible = false
	now_playing = get_node("../WhitePlayer")
	add_child(tween)
	tween.connect("tween_completed", self, "_done_moving")
	print("Now playing; ", now_playing)

func _process(delta: float) -> void:
	if captured_cursor:
		if _moving:
			_moving = false
			tween.stop_all()
		if position != get_global_mouse_position():
			var new_pos = board2realpos(real2boardpos(get_global_mouse_position()))
			var gp = real2boardpos(new_pos)
			$PositionLabel.text = str(gp)
			tween.interpolate_property(self, "position",
				position, new_pos, 0.02,
				Tween.TRANS_LINEAR, Tween.EASE_OUT)
			_moving = true
			tween.start()

func _input(event):
	if event.is_action_pressed("ui_select"):
		if hovering and !selected:
			self.selected = hovering
		elif selected:
			self.selected = null


func set_hovering(piece):
	hovering = piece

func set_selected(piece):
	if piece == null:
		print("dropped:", selected)
		var spp = selected.global_position
		remove_child(selected)
		selected_parent.add_child(selected)
		selected.global_position = spp
		selected_parent = null
		selected = null
	else:
		selected = piece
		print("Selected:", selected)
		selected_parent = selected.get_parent()
		var spp = selected.global_position
		selected_parent.remove_child(selected)
		add_child(selected)
		selected.global_position = spp

func set_movement_step(v):
	movement_step = v

func real2boardpos(pos, t_size=movement_step):
	return get_parent().real2boardpos(pos, t_size)

func board2realpos(bp, t_size=movement_step):
	var p = bp * t_size + t_size / 2
	return p

func _done_moving(_obj, _key):
	_moving = false

func moveEast(step=1):
	var bp = real2boardpos(position, movement_step)
	bp.x += step
	position = board2realpos(bp, movement_step)

func moveWest(step=1):
	var bp = real2boardpos(position)
	bp.x -= step
	position = board2realpos(bp)

func moveSouth(step=1):	
	var bp = real2boardpos(position)
	bp.y += step
	position = board2realpos(bp)

func moveNorth(step=1):
	var bp = real2boardpos(position)
	bp.y -= step
	position = board2realpos(bp)

