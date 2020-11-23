extends State

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
export(float) var FRICTION : float = 0.9
export(int) var GRAVITY : int = 2000
export(int) var MAX_GRAV : int = 1500

#Functions
func enter(base_fly : KinematicBody2D) -> void:
	base_fly._die()
	base_fly.change_animation("Dead")

func update(base_fly: KinematicBody2D, _delta : float) -> void:
	var spdx : float = base_fly.speed.x

	if base_fly.is_on_floor():
		base_fly.speed.y *= -0.5
		spdx *= FRICTION

	if abs(spdx) < 10: spdx = 0

	base_fly.speed.x = spdx

	base_fly.speed.y += GRAVITY*_delta
	if base_fly.speed.y > MAX_GRAV: base_fly.speed.y = MAX_GRAV

	# warning-ignore:return_value_discarded
	base_fly.move_and_slide(base_fly.speed, NORMAL)

	if base_fly.is_on_wall():
		base_fly.speed.x *= -FRICTION

	if base_fly.is_on_ceiling():
		base_fly.speed.y = 0
