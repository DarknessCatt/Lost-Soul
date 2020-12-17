extends State

const GRAV : int = 3500
const MAX_GRAV : int = 1500
const NORMAL : Vector2 = Vector2(0, -1)
const FRICTION : float = 0.75

var is_falling : bool = false

func enter(Player : KinematicBody2D) -> void:
	is_falling = false

	if Player.is_on_floor():
		Player._change_anim("Rest")
	else:
		Player._change_anim("Falling")
		is_falling = true

func update(Player: KinematicBody2D, delta : float) -> void:
	Player.speed.y += GRAV*delta
	if Player.speed.y > MAX_GRAV: Player.speed.y = MAX_GRAV

	var spdx : float = Player.speed.x * FRICTION
	if abs(spdx) < 10: spdx = 0

	Player.speed.x = spdx

	# warning-ignore:return_value_discarded
	Player.move_and_slide(Player.speed, NORMAL, true, 2)

	if is_falling and Player.is_on_floor():
		Player._change_anim("Rest")
		is_falling = false
