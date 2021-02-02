extends Area2D
class_name Cursor, "res://Images/cursor.png"


onready var game := get_node('/root/Game')
onready var HUDs := {
    grid_x_position = $HUD/Position/Grid/X,
    real_x_position = $HUD/Position/Real/X,
    grid_y_position = $HUD/Position/Grid/Y,
    real_y_position = $HUD/Position/Real/Y,
    current_player = $HUD/Game/Player,
    current_state = $HUD/Game/State,
    hovering = $HUD/Hovering,
    selected = $HUD/Selected
}
var disabled : bool = false
var movement_step
var hovering_piece 
var selected_piece
var legal_target_positions := []


func update_on_hud_position(real_position=null, grid_position=null) -> void:
    if typeof(grid_position) == TYPE_VECTOR2:
        HUDs['grid_x_position'].text = str(grid_position.x)
        HUDs['grid_y_position'].text = str(grid_position.y)
    else:
        HUDs['grid_x_position'].text = '-'
        HUDs['grid_y_position'].text = '-'
    if typeof(real_position) == TYPE_VECTOR2:
        HUDs['real_x_position'].text = str(int(real_position.x))
        HUDs['real_y_position'].text = str(int(real_position.y))
    else:
        HUDs['grid_x_position'].text = '-'
        HUDs['grid_y_position'].text = '-'

func real2boardpos(pos, t_size=null):
    # For convienience - although using Game's method  
    return get_node("/root/Game").real2boardpos(pos, t_size)

func board2realpos(bp, t_size=null):
    # For convienience - although using Game's method  
    return get_node("/root/Game").board2realpos(bp, t_size)

func move_snapped(real_position : Vector2) -> void:
    # Note: `real_position` is not the final position of the cursor.
    # It will instead be snapped to the closest valid position within the grid.
    # (ie: on the closest tile's center)
    # Use `move_freely` for an arbitrary destination.
    var bp = self.real2boardpos(real_position, movement_step)
    bp.y = max(0, min(bp.y, 7))
    bp.x = max(0, min(bp.x, 7))
    if real2boardpos(position, movement_step) != bp:
        position = board2realpos(bp, movement_step)
        update_on_hud_position(real_position, bp)
        Global.register_game_state(game.dict_game())

func move_freely(real_position : Vector2) -> void:
    # Moves the cursor to an arbitrary destination
    position = real_position
    update_on_hud_position(real_position, null)

func toggle_hud() -> void:
    $HUD.visible = !$HUD.visible

######################################################

func _ready():
    toggle_hud()

func _process(_delta: float) -> void:
    move_snapped(get_global_mouse_position())
    if selected_piece:
        selected_piece.global_position = global_position
