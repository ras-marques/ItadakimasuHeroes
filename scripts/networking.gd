extends Node

const IPADDRESS = "127.0.0.1"
const PORT = 6007
const MAXPLAYERS = 8

var ip = IPADDRESS
var id = 0
var player_name = ""
var peer = null
var players = []

func _ready():
	multiplayer.connected_to_server.connect(self.connecting_to_server)
	multiplayer.connection_failed.connect(self.connection_failed)
	multiplayer.server_disconnected.connect(self.server_disconnected)
	
func connecting_to_server():
	pass
	
func connection_failed():
	pass

func server_disconnected():
	pass
	
func create_server():
	pass
