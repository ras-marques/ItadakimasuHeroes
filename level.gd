extends Node2D

var packed_player = preload("res://scenes/player.tscn")

func _ready():
	var player_list = Networking.get_player_list()
	for i in range(player_list.size()):
		var obj = packed_player.instantiate()
		$Players.add_child(obj)
		obj.position = Vector2(512,300)
		obj.name = str(player_list[i][0]) #this is not the name of the player, it's the id, that's why we use the id, not the name, for godot internal stuff
		obj.set_multiplayer_authority(player_list[i][0])
		obj.set_player_name(player_list[i][1])
