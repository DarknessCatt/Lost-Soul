extends ConcurrentState

const NORMAL : Vector2 = Vector2(0, -1)

#Overridable Vars
##Movement Vars
const ACCEL : int = 2000
const MAX_SPEED : int = 400
const FRICTION : float = 0.75

func enter(_Machine : Node, Player : KinematicBody2D) -> void:
	if Input.is_action_pressed("hero_left"):
		Player.body.scale.x = -1

	elif Input.is_action_pressed("hero_right"):
		Player.body.scale.x = 1

	elif sign(Player.speed.x) != 0:
		Player.body.scale.x = sign(Player.speed.x)

func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:
	var direction : float = Input.get_action_strength("hero_right") - \
							Input.get_action_strength("hero_left")

	var spdx : float = Player.speed.x + direction*ACCEL*delta

	if sign(spdx) != direction: spdx *= FRICTION

	if abs(spdx) > MAX_SPEED: spdx = MAX_SPEED*direction
	elif abs(spdx) < 10: spdx = 0

	if Machine.action_state.name != "Attack":
		match sign(direction):
			-1.0:
				Player.body.scale.x = -1

			1.0:
				Player.body.scale.x = 1

	Player.speed.x = spdx

	# warning-ignore:return_value_discarded
	Player.move_and_slide(Player.speed, NORMAL, true, 2)
