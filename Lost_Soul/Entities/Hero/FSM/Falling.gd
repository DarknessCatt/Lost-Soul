extends Node

const GRAV : int = 5000
const MAX_GRAV : int = 1000
const NORMAL : Vector2 = Vector2(0, -1)

func enter(_Player : KinematicBody2D) -> void:
	_Player.speed.y = 20

func exit(_Player : KinematicBody2D) -> void:
	_Player.speed.y = 10

func update(_Player: KinematicBody2D, delta : float) -> void:
	_Player.speed.y += GRAV*delta
	_Player.move_and_slide(_Player.speed, NORMAL)

	if _Player.is_on_floor():
		_Player._change_state($"../OnGround")

func input(_Player: KinematicBody2D, event : InputEvent) -> void:
	pass
