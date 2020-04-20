extends "BasicMove.gd"

const GRAV : int = 3500
const MAX_GRAV : int = 1500

func _ready():
	MOVE_ANIMATION = "Falling"
	REST_ANIMATION = "Falling"

func enter(_Player : KinematicBody2D) -> void:

	.enter(_Player)

	if _Player.speed.y < 0:
		_Player.speed.y /= 1.5
	else:
		_Player.speed.y = 0

func exit(_Player : KinematicBody2D) -> void:
	_Player.speed.y = 10

func update(_Player: KinematicBody2D, delta : float) -> void:
	_Player.speed.y += GRAV*delta
	if _Player.speed.y > MAX_GRAV: _Player.speed.y = MAX_GRAV

	.update(_Player, delta)

	if _Player.is_on_floor():
		_Player._change_state($"../OnGround")

func input(_Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_pressed("hero_jump"):

		if $"../Buffer".can_coyote:
			_Player._change_state($"../Jumping")
		else:
			$"../Buffer"._buffer_jump()

	elif event.is_action_pressed("hero_attack"):
		_Player._change_state($"../AirAttack")

	else:
		.input(_Player, event)
