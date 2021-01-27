extends Node


var game_state : Dictionary 
var whites : Array
var blacks : Array


func register_game_state(gm : Dictionary) -> void:
	game_state = gm
	print("Registered game state:")
	print(game_state.values())

func pieces(only_color=null) -> Array:
	var pcs := []
	for p in game_state.values():
		if p and only_color == null or p and only_color == p.piece_color:
			pcs.append(p)
	return pcs

func piece_positions(only_color=null) -> Array:
	var positions := []
	for pos in game_state:
		if only_color == null or game_state[pos] and only_color == game_state[pos].piece_color:
			positions.append(game_state[pos])
	return positions


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
		if typeof(target_position) == TYPE_VECTOR2:
			targets.append(target_position)
		else:
			targets.append(
				Vector2(target_position[0], target_position[1]))
	
	func count() -> int:
		return len(targets)
	
	func clear() -> void:
		targets.clear()
