extends Node

const NORMAL : Vector2 = Vector2(0, -1)
const ACCEL : int = 3000
const MAX_SPEED : int = 300
const FRICTION : float = 0.75

#Direction Enum FSM
enum {LEFT = -1, NONE, RIGHT}
var direction : int = NONE

func enter(_Player : KinematicBody2D) -> void:
	if Input.is_action_pressed("hero_left"):
		direction = LEFT
		_Player.body.scale.x = -1
		_Player._change_anim("Walking")

	elif Input.is_action_pressed("hero_right"):
		direction = RIGHT
		_Player.body.scale.x = 1
		_Player._change_anim("Walking")

	else:
		direction = NONE
		_Player._change_anim("Rest")

func exit(_Player : KinematicBody2D) -> void:
	_Player._change_anim("Rest")

func update(_Player: KinematicBody2D, delta : float) -> void:
	var spdx : float = _Player.speed.x + direction*ACCEL*delta

	if sign(spdx) != direction : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED: spdx = MAX_SPEED*direction
	elif abs(spdx) < 10: spdx = 0

	if sign(spdx) != sign(_Player.speed.x):
		match sign(spdx):
			-1.0:
				_Player.body.scale.x = -1
				_Player._change_anim("Walking")
			0.0:
				_Player._change_anim("Rest")
			1.0:
				_Player.body.scale.x = 1
				_Player._change_anim("Walking")

	_Player.speed.x = spdx

	_Player.move_and_slide(_Player.speed, NORMAL)

	if not _Player.is_on_floor():
		_Player._change_state($"../Falling")

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
