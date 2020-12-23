extends HBoxContainer

var text : String = "" setget set_text


func set_text(s):
	text = s
	if text.begins_with('('):
		text = text.replace('(', '')
	if text.ends_with(')'):
		text = text.replace(')', '')
	text = text.replace(',', ':')
	var xy = text.split_floats(':')
	$X.text = str(xy[0])
	$Y.text = str(xy[1])
