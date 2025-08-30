extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_authority: bool:
	get: return !LowLevelNetworkHandler.is_server && owner_id == ClientNetworkGlobals.id

var owner_id: int

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_player_position.connect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.connect(client_handle_player_position)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_player_position.disconnect(server_handle_player_position)
	ClientNetworkGlobals.handle_player_position.disconnect(client_handle_player_position)
	

func _physics_process(delta: float) -> void:
	if !is_authority: return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	PlayerPosition.create(owner_id, global_position).send(LowLevelNetworkHandler.server_peer)

func server_handle_player_position(peer_id: int, player_position: PlayerPosition):
	if owner_id != peer_id: return
	
	global_position = player_position.position
	
	PlayerPosition.create(owner_id, global_position).broadcast(LowLevelNetworkHandler.connection)
	
func client_handle_player_position(player_position: PlayerPosition):
	if is_authority || owner_id != player_position.id: return
	
	global_position = player_position.position
