extends State

#State info
export(String) var state_anim : String = "Falling"

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
export(int) var ACCEL : int = 2000
export(int) var MAX_SPEED : int = 100
export(float) var FRICTION : float = 0.75
export(int) var GRAVITY : int = 3500
export(int) var MAX_GRAV : int = 2000
var dir : int = 1

#Functions
func enter(Wanderer : KinematicBody2D) -> void:
	Wanderer.change_animation(state_anim)
	# warning-ignore:narrowing_conversion
	dir = sign(Wanderer.speed.x)

func update(Wanderer: KinematicBody2D, _delta : float) -> void:
#	var spdx : float = Wanderer.speed.x + dir*ACCEL*_delta
#
#	if sign(spdx) != dir : spdx *= FRICTION
#
#	if abs(spdx) > MAX_SPEED:
#		# warning-ignore:integer_division
#		if abs(spdx) - MAX_SPEED < ACCEL/10 : spdx = MAX_SPEED*dir
#		else : spdx *= FRICTION
#
#	# warning-ignore:integer_division
#	elif abs(spdx) < ACCEL/100: spdx = 0
#
#	if sign(spdx) != sign(Wanderer.speed.x):
#		match sign(spdx):
#			-1.0:
#				Wanderer.body.scale.x = -1
#			1.0:
#				Wanderer.body.scale.x = 1
#
#	Wanderer.speed.x = spdx

	Wanderer.speed.x *= FRICTION

	Wanderer.speed.y += GRAVITY*_delta
	if Wanderer.speed.y > MAX_GRAV: Wanderer.speed.y = MAX_GRAV

	# warning-ignore:return_value_discarded
	Wanderer.move_and_slide(Wanderer.speed, NORMAL)

	if Wanderer.is_on_wall():
		Wanderer.speed.x *= -1

	if Wanderer.is_on_floor():
		Wanderer._change_state($"../Walking")
