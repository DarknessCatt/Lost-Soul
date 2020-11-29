extends State

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
export(float) var FRICTION : float = 0.7
export(int) var GRAVITY : int = 3500
export(int) var MAX_GRAV : int = 2000

#Functions
func enter(Lost_Soul : KinematicBody2D) -> void:
	Lost_Soul.change_animation("Dead")

func update(Lost_Soul: KinematicBody2D, _delta : float) -> void:
	var spdx : float = Lost_Soul.speed.x

	if Lost_Soul.is_on_floor():
		spdx *= FRICTION

	if abs(spdx) < 10: spdx = 0

	Lost_Soul.speed.x = spdx

	Lost_Soul.speed.y += GRAVITY*_delta
	if Lost_Soul.speed.y > MAX_GRAV: Lost_Soul.speed.y = MAX_GRAV

	# warning-ignore:return_value_discarded
	Lost_Soul.move_and_slide(Lost_Soul.speed, NORMAL, true, 2)

	if Lost_Soul.is_on_wall():
		Lost_Soul.speed.x *= -FRICTION

	if Lost_Soul.is_on_ceiling():
		Lost_Soul.speed.y = 0
