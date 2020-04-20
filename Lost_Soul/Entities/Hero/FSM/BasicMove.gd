extends "State.gd"

const NORMAL : Vector2 = Vector2(0, -1)

#Overridable Vars
##Movement Vars
var ACCEL : int = 2000
var MAX_SPEED : int = 400
var FRICTION : float = 0.75

##Animation Vars
var MOVE_ANIMATION : String
var REST_ANIMATION : String

#Direction Enum FSM
enum {LEFT = -1, NONE, RIGHT}
var direction : int = NONE

#func _ready():
#	#Overridable Vars
#	##Movement Vars
#	ACCEL = 3000
#	MAX_SPEED = 300
#	FRICTION = 0.75
#
#	##Animation Vars
#	MOVE_ANIMATION = "Walking"
#	REST_ANIMATION = "Rest"

func enter(_Player : KinematicBody2D) -> void:
	if Input.is_action_pressed("hero_left"):
		direction = LEFT
		_Player.body.scale.x = -1
		_Player._change_anim(MOVE_ANIMATION)

	elif Input.is_action_pressed("hero_right"):
		direction = RIGHT
		_Player.body.scale.x = 1
		_Player._change_anim(MOVE_ANIMATION)

	else:
		direction = NONE
		_Player._change_anim(REST_ANIMATION)

func update(_Player: KinematicBody2D, delta : float) -> void:
	var spdx : float = _Player.speed.x + direction*ACCEL*delta

	if sign(spdx) != direction : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED: spdx = MAX_SPEED*direction
	elif abs(spdx) < 10: spdx = 0

	if sign(spdx) != sign(_Player.speed.x):
		match sign(spdx):
			-1.0:
				_Player.body.scale.x = -1
			1.0:
				_Player.body.scale.x = 1

	_Player.speed.x = spdx

	_Player.move_and_slide(_Player.speed, NORMAL)

func input(_Player: KinematicBody2D, event : InputEvent) -> void:

	match(direction):

		NONE:
			if event.is_action_pressed("hero_left"):
				direction = LEFT
				_Player._change_anim(MOVE_ANIMATION)

			elif event.is_action_pressed("hero_right"):
				direction = RIGHT
				_Player._change_anim(MOVE_ANIMATION)

		LEFT:
			if event.is_action_pressed("hero_right"):
				direction = RIGHT

			elif event.is_action_released("hero_left"):
				if Input.is_action_pressed("hero_right"):
					direction = RIGHT
				else:
					direction = NONE
					_Player._change_anim(REST_ANIMATION)

		RIGHT:
			if event.is_action_pressed("hero_left"):
				direction = LEFT

			elif event.is_action_released("hero_right"):
				if Input.is_action_pressed("hero_left"):
					direction = LEFT
				else:
					direction = NONE
					_Player._change_anim(REST_ANIMATION)
