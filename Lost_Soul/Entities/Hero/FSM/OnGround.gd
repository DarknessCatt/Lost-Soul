extends Node

const NORMAL : Vector2 = Vector2(0, -1)
const ACCEL : int = 400
const MAX_SPEED : int = 400
const FRICTION : float = 0.75

#Direction Enum FSM
enum {LEFT = -1, NONE, RIGHT}
var direction : int = NONE

func enter(_Player : KinematicBody2D) -> void:
	if Input.is_action_pressed("hero_left"):
		direction = LEFT

	elif Input.is_action_pressed("hero_right"):
		direction = RIGHT

	else:
		direction = NONE

func exit(_Player : KinematicBody2D) -> void:
	pass

func update(_Player: KinematicBody2D, delta : float) -> void:
	var spdx : float = _Player.speed.x + direction*ACCEL*delta

	if sign(spdx) != direction : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED: spdx = MAX_SPEED*direction
	elif abs(spdx) < 0.5: spdx = 0

	_Player.speed.x = spdx

	_Player.move_and_slide(_Player.speed, NORMAL)

func input(_Player: KinematicBody2D, event : InputEvent) -> void:

	match(direction):

		NONE:
			if event.is_action_pressed("hero_left"):
				direction = LEFT

			elif event.is_action_pressed("hero_right"):
				direction = RIGHT

		LEFT:
			if event.is_action_pressed("hero_right"):
				direction = RIGHT

			elif event.is_action_released("hero_left"):
				direction = NONE

		RIGHT:
			if event.is_action_pressed("hero_left"):
				direction = LEFT

			elif event.is_action_released("hero_right"):
				direction = NONE
