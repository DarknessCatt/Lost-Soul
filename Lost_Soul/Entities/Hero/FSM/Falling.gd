extends "BasicMove.gd"

const GRAV : int = 3500
const MAX_GRAV : int = 1500

onready var buffer : Node = $"../Buffer"

func enter(Machine : Node, Player : KinematicBody2D) -> void:
	.enter(Machine, Player)

	if Player.speed.y < 0:
		Player.speed.y /= 1.5

func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:
	Player.speed.y += GRAV*delta
	if Player.speed.y > MAX_GRAV: Player.speed.y = MAX_GRAV

	.update(Machine, Player, delta)

	#if buffer.attack_buffered and buffer.can_attack:
	#	Machine.change_move_state($"../AirAttack")

	if Player.is_on_floor():
		if buffer.jump_buffered:
			Machine.change_move_state($"../Jumping")

		else:
			Machine.change_move_state($"../OnGround")

func input(Machine : Node, Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_pressed("hero_jump"):

		if buffer.can_coyote:
			Machine.change_move_state($"../Jumping")
		else:
			buffer._buffer_jump()

	#elif event.is_action_pressed("hero_attack"):
	#		Machine.change_move_state($"../AirAttack")

	else:
		.input(Machine, Player, event)
