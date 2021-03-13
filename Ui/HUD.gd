extends CanvasLayer


export(NodePath) onready var grid_x_position = get_node(grid_x_position) as Label
export(NodePath) onready var real_x_position = get_node(real_x_position) as Label
export(NodePath) onready var grid_y_position = get_node(grid_y_position) as Label
export(NodePath) onready var real_y_position = get_node(real_y_position) as Label
export(NodePath) onready var legal_moves = get_node(legal_moves) as Label
export(NodePath) onready var game_state = get_node(game_state) 


func show_game_state(gdict):
	game_state.text = str(gdict)

func toggle_hud() -> void:
	$HUD.visible = !$HUD.visible

func update_on_hud_position(real_position=null, grid_position=null) -> void:
	if typeof(grid_position) == TYPE_VECTOR2:
		grid_x_position.text = str(grid_position.x)
		grid_y_position.text = str(grid_position.y)
	else:
		grid_x_position.text = '-'
		grid_y_position.text = '-'
	if typeof(real_position) == TYPE_VECTOR2:
		real_x_position.text = str(int(real_position.x))
		real_y_position.text = str(int(real_position.y))
	else:
		grid_x_position.text = '-'
		grid_y_position.text = '-'

func set_legal_moves(s):
	legal_moves.text = s
