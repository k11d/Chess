extends ChessPiece
class_name Knight, "res://Images/knight.png"



func get_available_moves():
    var x := grid_position.x
    var y := grid_position.y
    var candidates := [
        Vector2(x + 1, y - 2),
        Vector2(x - 1, y - 2),
        Vector2(x + 2, y - 1),
        Vector2(x + 2, y + 1),
        Vector2(x - 1, y + 2),
        Vector2(x - 2, y + 1),
        Vector2(x - 2, y - 1),
        Vector2(x + 1, y + 2)
    ]
    
    var allies_positions = Global.piece_positions(piece_color)
    var enemy_positions
    if piece_color == 'White':
        enemy_positions = Global.piece_positions('Black')
    else:
        enemy_positions = Global.piece_positions('White')
    var final := _targets_wrapper.new()
    for pos in candidates:
        if pos.x < 0 or pos.x > 7 or pos.y < 0 or pos.y > 7 or pos in allies_positions:
            continue
        elif pos in enemy_positions:
            final.add_target(pos, Color.red)
        else:
            final.add_target(pos, Color.blue)
            
    return final
