extends State

#State info
export(String) var state_anim : String = "Dead"

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
export(float) var FRICTION : float = 0.7
export(int) var GRAVITY : int = 3500
export(int) var MAX_GRAV : int = 2000

#Functions
func enter(Test_Wanderer : KinematicBody2D) -> void:
	Test_Wanderer.change_animation(state_anim)

func update(Test_Wanderer : KinematicBody2D, delta : float) -> void:
	var spdx : float = Test_Wanderer.speed.x

	if Test_Wanderer.is_on_floor():
		spdx *= FRICTION

	if abs(spdx) < 10: spdx = 0

	Test_Wanderer.speed.x = spdx

	Test_Wanderer.speed.y += GRAVITY*delta
	if Test_Wanderer.speed.y > MAX_GRAV: Test_Wanderer.speed.y = MAX_GRAV

	# warning-ignore:return_value_discarded
	Test_Wanderer.move_and_slide(Test_Wanderer.speed, NORMAL)

	if Test_Wanderer.is_on_wall():
		Test_Wanderer.speed.x *= -FRICTION

	if Test_Wanderer.is_on_ceiling():
		Test_Wanderer.speed.y = 0
