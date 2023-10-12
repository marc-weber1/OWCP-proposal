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
