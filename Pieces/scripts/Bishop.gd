extends ChessPiece
class_name Bishop, "res://Images/bishop.png"



func get_available_moves():
    var allies_positions = Global.piece_positions(piece_color)
    var enemy_positions
    if piece_color == "White":
        enemy_positions = Global.piece_positions("Black")
    else:
        enemy_positions = Global.piece_positions("White")
    
    var candidates := _targets_wrapper.new()
    var x := grid_position.x
    var y := grid_position.y
    var p : Vector2
    
    # NE
    while x > 0 and x < 7 and y > 0 and y < 7:
        x += 1
        y -= 1
        p = Vector2(x,y)
        if p in enemy_positions:
            candidates.add_target(p, Color.red)
            break
        if p in allies_positions:
            break
        candidates.add_target(p, Color.blue)
    
    # NW
    x = grid_position.x
    y = grid_position.y
    while x > 0 and x < 7 and y > 0 and y < 7:
        x -= 1
        y -= 1
        p = Vector2(x,y)
        if p in enemy_positions:
            candidates.add_target(p, Color.red)
            break
        if p in allies_positions:
            break
        candidates.add_target(p, Color.blue)
    
    # SE
    x = grid_position.x
    y = grid_position.y
    while x > 0 and x < 7 and y > 0 and y < 7:
        x += 1
        y += 1
        p = Vector2(x,y)
        if p in enemy_positions:
            candidates.add_target(p, Color.red)
            break
        if p in allies_positions:
            break
        candidates.add_target(p, Color.blue)
    
    # SW
    x = grid_position.x
    y = grid_position.y
    while x > 0 and x < 7 and y > 0 and y < 7:
        x -= 1
        y += 1
        p = Vector2(x,y)
        if p in enemy_positions:
            candidates.add_target(p, Color.red)
            break
        if p in allies_positions:
            break
        candidates.add_target(p, Color.blue)
    return candidates
