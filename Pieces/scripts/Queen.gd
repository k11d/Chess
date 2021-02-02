extends ChessPiece
class_name Queen, "res://Images/queen.png"


func get_available_moves():
    var allies_positions = Global.piece_positions(piece_color)
    var enemy_positions
    if piece_color == "White":
        enemy_positions = Global.piece_positions("Black")
    else:
        enemy_positions = Global.piece_positions("White")
    
    var p : Vector2
    var targets := []
    
    # Rook-like logic
    # EAST
    p = Vector2(grid_position.x, grid_position.y)
    while p.x < 7 and !(p in allies_positions):
        p.x += 1
        if p in enemy_positions:
            targets.append(p)
            break
    # WEST			
    p = Vector2(grid_position.x, grid_position.y)
    while p.x > 0 and !(p in allies_positions):
        p.x -= 1
        if p in enemy_positions:
            targets.append(p)
            break
    # SOUTH		
    p = Vector2(grid_position.x, grid_position.y)	
    while p.y < 7 and !(p in allies_positions):
        p.y += 1
        if p in enemy_positions:
            targets.append(p)
            break
    # NORTH
    p = Vector2(grid_position.x, grid_position.y)	
    while p.y > 0 and !(p in allies_positions):
        p.y -= 1
        if p in enemy_positions:
            targets.append(p)
            break

    # Bishop-like logic
    var x = grid_position.x
    var y = grid_position.y
    
    # NE
    while x > 0 and x < 7 and y > 0 and y < 7:
        x += 1
        y -= 1
        p = Vector2(x,y)
        if p in enemy_positions:
            targets.append(Vector2(x, y))
            break
        if p in allies_positions:
            break
        targets.append(Vector2(x, y))
    
    # NW
    x = grid_position.x
    y = grid_position.y
    while x > 0 and x < 7 and y > 0 and y < 7:
        x -= 1
        y -= 1
        p = Vector2(x,y)
        if p in enemy_positions:
            targets.append(Vector2(x, y))
            break
        if p in allies_positions:
            break
        targets.append(Vector2(x, y))
    
    # SE
    x = grid_position.x
    y = grid_position.y
    while x > 0 and x < 7 and y > 0 and y < 7:
        x += 1
        y += 1
        p = Vector2(x,y)
        if p in enemy_positions:
            targets.append(Vector2(x, y))
            break
        if p in allies_positions:
            break
        targets.append(Vector2(x, y))
    
    # SW
    x = grid_position.x
    y = grid_position.y
    while x > 0 and x < 7 and y > 0 and y < 7:
        x -= 1
        y += 1
        p = Vector2(x,y)
        if p in enemy_positions:
            targets.append(Vector2(x, y))
            break
        if p in allies_positions:
            break
        targets.append(Vector2(x, y))
    return _targets_wrapper.new().from_array(targets)

