extends Node

const IPADDRESS = "127.0.0.1"
const PORT = 6007
const MAXPLAYERS = 8

var ip = IPADDRESS
var id = 0
var player_name = ""
var peer = null
var players = []

signal updated_list

func _ready():
	multiplayer.connected_to_server.connect(self.connected_to_server)
	multiplayer.connection_failed.connect(self.connection_failed)
	multiplayer.server_disconnected.connect(self.server_disconnected)
	
func connected_to_server():
	id = multiplayer.multiplayer_peer.get_unique_id()
	rpc("register_player", id, player_name)

func peer_disconnected(id):
	pass

func connection_failed():
	pass

func server_disconnected():
	pass

@rpc("any_peer")
func register_player(id, name):
	if multiplayer.is_server():
		for i in range(players.size()):
			rpc_id(id, "register_player", players[i][0], players[i][1])
		rpc("register_player", id, name)
	players.append([id, name])
	emit_signal("updated_list")

func create_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAXPLAYERS)
	multiplayer.set_multiplayer_peer(peer)
	peer.peer_disconnected.connect(self.peer_disconnected)
	id = multiplayer.multiplayer_peer.get_unique_id()
	register_player(id, player_name)

func create_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.set_multiplayer_peer(peer)

func update_ip(new_ip):
	ip = new_ip

func update_name(new_name):
	player_name = new_name
	
func get_player_list():
	return players
