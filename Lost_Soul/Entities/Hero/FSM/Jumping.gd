extends Node

const GRAV : int = 5000
const MAX_GRAV : int = 1000
const NORMAL : Vector2 = Vector2(0, -1)

const JUMP_FORCE = 1500

func enter(_Player : KinematicBody2D) -> void:
	_Player.speed.y -= JUMP_FORCE
	if not Input.is_action_pressed("hero_jump"):
		_Player._change_state($"../Falling")

func exit(_Player : KinematicBody2D) -> void:
	pass

func update(_Player: KinematicBody2D, delta : float) -> void:
	_Player.speed.y += GRAV*delta
	_Player.move_and_slide(_Player.speed, NORMAL)

	if _Player.speed.y > 0 or _Player.is_on_ceiling():
		_Player._change_state($"../Falling")

func input(_Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_released("hero_jump"):
		_Player._change_state($"../Falling")
