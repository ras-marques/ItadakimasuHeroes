extends Node

const IPADDRESS = "127.0.0.1"
const PORT = 9001
const MAXPLAYERS = 8

var ip = IPADDRESS
var id = 0
var player_name = ""
var peer = null
var players = []

signal updated_list

var upnp
var external_ip = "NOT ACQUIRED"

func _ready():
	multiplayer.connected_to_server.connect(self.connected_to_server)
	multiplayer.connection_failed.connect(self.connection_failed)
	multiplayer.server_disconnected.connect(self.server_disconnected)
	upnp = UPNP.new()
	
func connected_to_server():
	id = multiplayer.multiplayer_peer.get_unique_id()
	rpc("register_player", id, player_name)

func peer_disconnected(player_id):
	rpc("remove_player", player_id)

func connection_failed():
	peer = null
	multiplayer.set_multiplayer_peer(null)

func server_disconnected():
	get_tree().quit()

@rpc("any_peer")
func register_player(new_player_id, new_player_name):
	if multiplayer.is_server():
		print("multiplayer is server")
		for i in range(players.size()):
			rpc_id(new_player_id, "register_player", players[i][0], players[i][1])
		rpc("register_player", new_player_id, new_player_name)
	players.append([new_player_id, new_player_name])
	emit_signal("updated_list")

@rpc("any_peer", "call_local")
func remove_player(player_id):
	for i in range(players.size()):
		if players[i][0] == player_id:
			players.remove_at(i)
			emit_signal("updated_list")
			return

func create_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAXPLAYERS)
	multiplayer.set_multiplayer_peer(peer)
	peer.peer_disconnected.connect(self.peer_disconnected)
	id = multiplayer.multiplayer_peer.get_unique_id()
	register_player(id, player_name)
	
	var upnp = UPNP.new()
	var discover_result = upnp.discover()
	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			var map_result_udp = upnp.add_port_mapping(9001,0,"itasdakimasu_heroes", "UDP", 0)
			var map_result_tcp = upnp.add_port_mapping(9001,0,"itasdakimasu_heroes", "TCP", 0)
			if not map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(9001,9001,"","UDP")
			if not map_result_tcp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(9001,9001,"","TCP")
	
	external_ip = upnp.query_external_address()
		

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

func get_ip():
#	var ip_list = IP.get_local_addresses()
#	for i in range(ip_list.size()):
#		if ip_list[i].begins_with("192"):
#			return ip_list[i]
	return external_ip
