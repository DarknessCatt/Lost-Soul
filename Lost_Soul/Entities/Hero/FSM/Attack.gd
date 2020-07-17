extends ConcurrentState

onready var buffer : Node = $"../Buffer"

var air_state : bool = false

var attack_finished : bool = false
var left_attack : bool = false

func enter(Machine : Node, Player : KinematicBody2D) -> void:
	attack_finished = false
	air_state = false

	var attack : String
	var timer : Timer

	if Machine.move_state.name == "OnGround":
		if Input.is_action_pressed("hero_down"):
			attack = "Jab_Down"
			timer = $DownTilt

		elif Input.is_action_pressed("hero_up"):
			attack = "Jab_Up"
			timer = $UpTilt

		else:
			attack = "Jab_Right"
			timer = $Jab

			if left_attack: attack = "Jab_Left"
			left_attack = not left_attack

	else:
		air_state = true

		if Input.is_action_pressed("hero_down"):
			attack = "Air_Jab_Down"
			timer = $AirDownTilt

		elif Input.is_action_pressed("hero_up"):
			attack = "Air_Jab_Up"
			timer = $AirUpTilt

		else:
			attack = "Air_Jab"
			timer = $AirJab

	Player._reset_anim(attack)
	timer.start()

func exit(Machine : Node, Player : KinematicBody2D) -> void:
	Player._clear_attack_polys()
	Player._disable_hitboxes()

func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:
	if attack_finished:
		if buffer.attack_buffered:
			Machine.change_action_state($"../Attack")

		else:
			Machine.change_action_state($"../Idle")

func input(Machine : Node, Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_pressed("hero_attack"):
		buffer._buffer_attack()

	elif event.is_action_pressed("hero_block"):
		Machine.change_action_state($"../Blocking")

func move_state_changed(Machine : Node, Player: KinematicBody2D) -> void:
	var is_ground : bool = Machine.move_state.name == "OnGround"

	if not (air_state or is_ground) or (air_state and is_ground):
		if buffer.attack_buffered:
			Machine.change_action_state($"../Attack")

		else:
			Machine.change_action_state($"../Idle")

func _on_Attack_timeout():
	attack_finished = true
