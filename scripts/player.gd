extends Node2D

var player_name = ""
var window_size = Vector2(0,0)
func _ready():
	window_size = DisplayServer.window_get_size()

func _process(_delta):
	if is_multiplayer_authority():
		print(DisplayServer.window_get_size())
		var new_position = get_viewport().get_mouse_position()
		if new_position.x > 0 and new_position.x < window_size.x and new_position.y > 0 and new_position.y < window_size.y:
			position = new_position
		print(position)

func set_player_name(new_name):
	$PlayerName.text = new_name
