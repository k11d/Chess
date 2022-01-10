extends Node
class_name Targets


var targets := []
var colors := []
var capture_flag := []

func clear():
    targets.clear()
    colors.clear()

func add_target(pos: Vector2, color : Color = Color.white, capturing : bool = false) -> void:
    targets.append(pos)
    colors.append(color)
    capture_flag.append(capturing)

func remove_target(pos) -> void:
    var index = targets.find(pos)
    targets.remove(index)
    colors.remove(index)
    capture_flag.remove(index)

func _to_string() -> String:
    var s := ""
    for t in targets:
        s += str(t) + '\n'
    return s
