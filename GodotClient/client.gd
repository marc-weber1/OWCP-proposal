extends Node
class_name Client

@export var SERVER_URL = "gaydogs.club"
@export var SERVER_PORT = 80

var user_scene = preload("res://user.tscn")

var users = {}


func _ready():
	
	# Connect to Server
	
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	multiplayer.server_disconnected.connect(_server_disconnected)
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_URL, SERVER_PORT)
	multiplayer.multiplayer_peer = peer


# Server Connections

func _peer_connected(id):
	if id != 1:
		print("Peer connected with ID ", id)
		users[id] = user_scene.instantiate()
		add_child(users[id])
	
func _peer_disconnected(id):
	if id != 1:
		print("Peer disconnected with ID ", id)
		users[id].queue_free()
		users.erase(id)

func _connected_to_server():
	print("Connected to server ", SERVER_URL, ":", SERVER_PORT)
	
func _connection_failed():
	print("Failed to connect to server ", SERVER_URL, ":", SERVER_PORT)
	
func _server_disconnected():
	print("Server disconnected.")


## Voice

@rpc("any_peer", "unreliable")
func on_voice_packet_received(packet: PackedByteArray):
	var sender_id = multiplayer.get_remote_sender_id()
	users[sender_id].stream.push_packet(packet)


## Bones

@rpc("any_peer", "unreliable")
func on_bone_update(updated_bones: PackedByteArray):
	pass


## Blendshapes

@rpc("any_peer", "unreliable")
func on_blendshape_update(updated_blendshapes: PackedByteArray):
	pass


## Position

@rpc("any_peer", "unreliable")
func on_position_update(updated_position: Vector2):
	pass


## World Loading

@rpc("reliable")
func on_world_change_url(url: String):
	pass

@rpc("reliable")
func on_world_change(file: PackedByteArray):
	pass

@rpc("any_peer", "reliable")
func request_world_change_url(url: String):
	on_world_change_url.rpc(url)

@rpc("any_peer", "reliable")
func request_world_change(file: PackedByteArray):
	on_world_change.rpc(file)


## Avatar Loading

@rpc("any_peer", "reliable")
func peer_changed_avatar(file: PackedByteArray):
	pass


## Height Change

@rpc("reliable")
func on_height_change(peer_id: int, height: float):
	pass

@rpc("any_peer", "reliable")
func request_height_change(height: float):
	var peer_id = multiplayer.get_remote_sender_id()
	on_height_change.rpc(peer_id, height)


## Interaction

@rpc("any_peer", "reliable")
func interact():
	pass

@rpc("any_peer", "reliable")
func grab():
	pass


## Playspace Updates

@rpc("any_peer", "reliable")
func update_playspace(file: PackedByteArray):
	pass
