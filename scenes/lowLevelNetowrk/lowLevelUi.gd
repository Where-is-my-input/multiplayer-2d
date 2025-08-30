extends Control

func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_disconnected)

func _on_btn_client_pressed() -> void:
	LowLevelNetworkHandler.start_client()


func _on_btn_server_pressed() -> void:
	print("Starting server...")
	LowLevelNetworkHandler.start_server()

	if multiplayer.is_server():
		print("Server started, spawning player...")
		var player_scene = load("res://scenes/player.tscn")
		var player = player_scene.instantiate()
		player.name = "1"  # Server has peer ID 1
		player.position = Vector2(455, 79)
		get_tree().current_scene.add_child(player)
		print("Server player spawned with name: ", player.name)
		set_buttons_visibility(false)
	else:
		print("Failed to start server or not server")

func _on_connected_to_server() -> void:
	set_buttons_visibility(false)

func _on_disconnected() -> void:
	set_buttons_visibility(true)

func set_buttons_visibility(should_show: bool) -> void:
	$VBoxContainer/btnServer.visible = should_show
	$VBoxContainer/btnClient.visible = should_show
