extends Node


class TurnState:
	enum NowPlaying {White, Black}
	enum State {ToPick, Picked}
	var now_playing
	var state
	
	func _init():
		now_playing = NowPlaying.White
		state = State.ToPick



class TargetedPositions:
	
	enum MarkerColor {Red, Green, Blue}
	var targets : Array
	
	func _init() -> void:
		targets = []
	
	func _to_string() -> String:
		var s = "Target(s) position(s): "
		for elem in targets:
			s += "\n" + "\t" + str(elem)
		return s
	
	func get_all() -> Array:
		return targets
	
	func add(target_position) -> void:
		targets.append(
			Vector2(target_position[0], target_position[1]))
	
	func count() -> int:
		return len(targets)
	
	func clear() -> void:
		targets.clear()


