extends ChessPiece
class_name Bishop, "res://Images/bishop.png"


func get_available_moves():
    var allies_positions = Global.piece_positions(piece_color)
    var enemy_positions
    if piece_color == "White":
        enemy_positions = Global.piece_positions("Black")
    else:
        enemy_positions = Global.piece_positions("White")
    
    var targets := _targets_wrapper.new()
    var x := grid_position.x
    var y := grid_position.y
    var p : Vector2
    
    # NE
    while x < 7 and y > 0:
        x += 1
        y -= 1
        p = Vector2(x,y)
        if p in enemy_positions:
            targets.add_target(p, Color.red, true)
            break
        if p in allies_positions:
            break
        targets.add_target(p, Color.blue, false)
    
    # NW
    x = grid_position.x
    y = grid_position.y
    while x > 0 and y > 0:
        x -= 1
        y -= 1
        p = Vector2(x,y)
        if p in enemy_positions:
            targets.add_target(p, Color.red, true)
            break
        if p in allies_positions:
            break
        targets.add_target(p, Color.blue, false)
    
    # SE
    x = grid_position.x
    y = grid_position.y
    while x < 7 and y < 7:
        x += 1
        y += 1
        p = Vector2(x,y)
        if p in enemy_positions:
            targets.add_target(p, Color.red, true)
            break
        if p in allies_positions:
            break
        targets.add_target(p, Color.blue, false)
    
    # SW
    x = grid_position.x
    y = grid_position.y
    while x > 0 and y < 7:
        x -= 1
        y += 1
        p = Vector2(x,y)
        if p in enemy_positions:
            targets.add_target(p, Color.red, true)
            break
        if p in allies_positions:
            break
        targets.add_target(p, Color.blue, false)
    return targets
