extends Node
class_name Targets


var targets := []
var colors := []
var capture_flag := []
var count := 0

func clear():
    targets.clear()
    colors.clear()
    count = 0

func add_target(pos: Vector2, color : Color = Color.white, capturing : bool = false) -> void:
    targets.append(pos)
    colors.append(color)
    capture_flag.append(capturing)
    count += 1

func get_target_info(pos) -> Array:
    var index = targets.find(pos)
    return [pos, capture_flag[index]]

func remove_target(pos) -> void:
    var index = targets.find(pos)
    targets.remove(index)
    colors.remove(index)
    capture_flag.remove(index)
    count -= 1

func _to_string() -> String:
    var s := ""
    for t in targets:
        s += str(t) + '\n'
    return s
