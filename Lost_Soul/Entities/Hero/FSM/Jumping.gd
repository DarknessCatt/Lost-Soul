extends "BasicMove.gd"

const GRAV : int = 2300

const JUMP_FORCE = 1100

onready var buffer : Node = $"../Buffer"

func enter(Machine : Node, Player : KinematicBody2D) -> void:
	.enter(Machine, Player)

	Player.speed.y = -JUMP_FORCE

	if not Input.is_action_pressed("hero_jump"):
		Machine.change_move_state($"../Falling")

func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:
	Player.speed.y += GRAV*delta

	.update(Machine, Player, delta)

	if Player.speed.y > 0 or Player.is_on_ceiling():
		Player.speed.y = 0
		Machine.change_move_state($"../Falling")

func input(Machine : Node, _Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_released("hero_jump"):
		Machine.change_move_state($"../Falling")
