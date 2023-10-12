extends Node

var DEFAULT_PORT = 80
var DEFAULT_MAX_PEERS = 80


func _ready():

	var args = {}
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			args[key_value[0].lstrip("--")] = key_value[1]
		else:
			# Options without an argument will be present in the dictionary,
			# with the value set to an empty string.
			args[argument.lstrip("--")] = ""
	
	var port = DEFAULT_PORT
	if args.has('port'):
		port = int(args['port'])
	
	var max_peers = DEFAULT_MAX_PEERS
	if args.has('max-peers'):
		max_peers = int(args['max-peers'])
	
	var peer = ENetMultiplayerPeer.new()
	print("[INFO] Starting server...")
	peer.create_server(port, max_peers)
	multiplayer.multiplayer_peer = peer
	assert(multiplayer.is_server())
	
	print("[INFO] Server running on port " + str(port))


## Voice

@rpc("any_peer", "unreliable")
func on_voice_packet_received(packet: PackedByteArray):
	pass


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