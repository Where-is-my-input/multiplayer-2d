extends Control

func _on_btn_client_pressed() -> void:
	HighLevelNetworkHandler.startClient()


func _on_btn_server_pressed() -> void:
	HighLevelNetworkHandler.startServer()
