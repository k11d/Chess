extends Node


class TurnState:
	
	enum NowPlaying {White, Black}
	enum State {ToPick, ToPlay}
	var now_playing
	var state
	var _printable_str : String setget ,_update_printable_str
	
	func _init():
		now_playing = NowPlaying.White
		state = State.ToPick
		
	func _update_printable_str() -> String:
		_printable_str = ''
		match now_playing:
			NowPlaying.White:
				_printable_str += 'White '
			NowPlaying.Black:
				_printable_str += 'Black '
		match state:
			State.ToPick:
				_printable_str += 'to pick '
			State.ToPlay:
				_printable_str += 'to play '
		return _printable_str
	
	func _to_string() -> String:
		return self._update_printable_str()

	func next_player() -> void:
		match now_playing:
			NowPlaying.White:
				now_playing = NowPlaying.Black
			NowPlaying.Black:
				now_playing = NowPlaying.White
		state = State.ToPick
		
	func player_picked() -> void:
		state = State.ToPlay
	
	func player_cancelled() -> void:
		state = State.ToPick

	func player_played() -> void:
		next_player()


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


