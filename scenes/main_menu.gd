extends Control

func _ready():
	Networking.updated_list.connect(self.updated_list)
	
func _on_host_server_pressed():
	Networking.update_name($MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer2/NameEdit.text)
	Networking.create_server()


func _on_join_server_pressed():
	Networking.update_ip($MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer/IpEdit.text)
	Networking.update_name($MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HBoxContainer2/NameEdit.text)
	Networking.create_client()


func _on_start_game_pressed():
	pass # Replace with function body.

func updated_list():
	var list = Networking.get_player_list()
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerList.clear()
	for i in range(list.size()):
		$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerList.add_item(list[i][1])
