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
func enter(Player : KinematicBody2D) -> void:
	Player.change_animation(state_anim)
	# warning-ignore:narrowing_conversion
	dir = sign(Player.speed.x)

func update(Player: KinematicBody2D, _delta : float) -> void:
	var spdx : float = Player.speed.x + dir*ACCEL*_delta

	if sign(spdx) != dir : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED:
		# warning-ignore:integer_division
		if abs(spdx) - MAX_SPEED < ACCEL/10 : spdx = MAX_SPEED*dir
		else : spdx *= FRICTION

	# warning-ignore:integer_division
	elif abs(spdx) < ACCEL/100: spdx = 0

	if sign(spdx) != sign(Player.speed.x):
		match sign(spdx):
			-1.0:
				Player.body.scale.x = -1
			1.0:
				Player.body.scale.x = 1

	Player.speed.x = spdx

	Player.speed.y += GRAVITY*_delta
	if Player.speed.y > MAX_GRAV: Player.speed.y = MAX_GRAV

	# warning-ignore:return_value_discarded
	Player.move_and_slide(Player.speed, NORMAL)

	if Player.is_on_wall():
		Player.speed.x *= -1

	if Player.is_on_floor():
		Player._change_state($"../Walking")
