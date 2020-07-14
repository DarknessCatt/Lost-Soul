extends "BasicMove.gd"

onready var buffer : Node = $"../Buffer"

func enter(Machine : Node, Player : KinematicBody2D) -> void:
	Player.speed.y = 10
	.enter(Machine, Player)

func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:

	.update(Machine, Player, delta)

	if not Player.is_on_floor():
		buffer._coyote_timer()
		Machine.change_move_state($"../Falling")


func input(Machine : Node, Player: KinematicBody2D, event : InputEvent) -> void:

	if event.is_action_pressed("hero_jump"):
		Machine.change_move_state($"../Jumping")

	#elif event.is_action_pressed("hero_attack"):
	#	Player._change_state($"../GroundAttack")

	else:
		.input(Machine, Player, event)
