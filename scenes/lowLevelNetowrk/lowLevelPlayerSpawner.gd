extends Node

const LLN_PLAYER = preload("res://scenes/lln_player.tscn")

func _ready() -> void:
	LowLevelNetworkHandler.on_peer_connected.connect(spawn_player)
	ClientNetworkGlobals.handle_local_id_assignment.connect(spawn_player)
	ClientNetworkGlobals.handle_remote_id_assignment.connect(spawn_player)

func spawn_player(id: int):
	var player = LLN_PLAYER.instantiate()
	player.owner_id = id
	player.name = str(id)
	
	call_deferred("add_child", player)
