extends Control

func _ready():
	Networking.updated_list.connect(self.updated_list)
	
func _on_host_server_pressed():
	Networking.update_name($MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer2/NameEdit.text)
	Networking.create_server()
	$MarginContainer/VBoxContainer/HBoxContainer2/HostServer.disabled = true
	$MarginContainer/VBoxContainer/HBoxContainer2/JoinServer.disabled = true
	var ip = Networking.get_ip()
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ServerIP.text = ip
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ServerON.visible = true
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ServerIP.visible = true
	$MarginContainer/VBoxContainer/HBoxContainer2/StartGame.disabled = false

func _on_join_server_pressed():
	Networking.update_ip($MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer/IpEdit.text)
	Networking.update_name($MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer2/NameEdit.text)
	Networking.create_client()
	$MarginContainer/VBoxContainer/HBoxContainer2/HostServer.disabled = true
	$MarginContainer/VBoxContainer/HBoxContainer2/JoinServer.disabled = true


func _on_start_game_pressed():
	if multiplayer.is_server():
		rpc("start_game")

@rpc("any_peer","call_local")
func start_game():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func updated_list():
	var list = Networking.get_player_list()
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerList.clear()
	for i in range(list.size()):
		if list[i][0] == Networking.id:
			$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerList.add_item(list[i][1] + str(" (You)"))
		else:
			$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerList.add_item(list[i][1])
