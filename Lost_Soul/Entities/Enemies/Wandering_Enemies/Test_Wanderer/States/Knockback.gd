extends State

#State info
export(String) var state_anim : String = "Falling"

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
export(float) var FRICTION : float = 0.7
export(int) var GRAVITY : int = 3500
export(int) var MAX_GRAV : int = 2000

#Functions
func enter(_Player : KinematicBody2D) -> void:
	_Player.change_animation(state_anim)

func update(_Player: KinematicBody2D, _delta : float) -> void:
	var spdx : float = _Player.speed.x

	if _Player.is_on_floor():
		spdx *= FRICTION

	if sign(spdx) != sign(_Player.speed.x):
		match sign(spdx):
			-1.0:
				_Player.body.scale.x = -1
			1.0:
				_Player.body.scale.x = 1

	_Player.speed.x = spdx

	_Player.speed.y += GRAVITY*_delta
	if _Player.speed.y > MAX_GRAV: _Player.speed.y = MAX_GRAV

	_Player.move_and_slide(_Player.speed, NORMAL)

	if _Player.is_on_wall():
		_Player.speed.x *= -FRICTION

	if _Player.is_on_ceiling():
		_Player.speed.y = 0

	if _Player.is_on_floor() and spdx < 10:
		_Player._change_state($"../Walking")