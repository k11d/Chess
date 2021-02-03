extends Node
class_name Targets

var targets := []
var colors := []

func add_target(pos: Vector2, color : Color = Color.white) -> void:
    targets.append(pos)
    colors.append(color)

func remove_target(pos) -> void:
    var index = targets.find(pos)
    targets.remove(index)
    colors.remove(index)

func from_array(arr : Array, colors : Array = []) -> Targets:
    while len(colors) < len(arr):
        colors.append(Color.white)
    for i in range(len(arr)):
        targets.append(arr[i])
        self.colors.append(colors[i])
    return self
