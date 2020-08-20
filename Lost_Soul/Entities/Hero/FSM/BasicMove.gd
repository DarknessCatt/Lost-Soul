extends ConcurrentState

const NORMAL : Vector2 = Vector2(0, -1)

#Overridable Vars
##Movement Vars
const ACCEL : int = 2000
const MAX_SPEED : int = 400
const FRICTION : float = 0.75

#Direction Enum FSM
enum {LEFT = -1, NONE, RIGHT}
var direction : int = NONE

func enter(_Machine : Node, Player : KinematicBody2D) -> void:
	if Input.is_action_pressed("hero_left"):
		direction = LEFT
		Player.body.scale.x = -1

	elif Input.is_action_pressed("hero_right"):
		direction = RIGHT
		Player.body.scale.x = 1

	else:
		direction = NONE

func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:
	var spdx : float = Player.speed.x + direction*ACCEL*delta

	if sign(spdx) != direction : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED: spdx = MAX_SPEED*direction
	elif abs(spdx) < 10: spdx = 0

	if Machine.action_state.name != "Attack" and \
		sign(spdx) != sign(Player.speed.x):
		match sign(spdx):
			-1.0:
				Player.body.scale.x = -1
			1.0:
				Player.body.scale.x = 1

	Player.speed.x = spdx

	# warning-ignore:return_value_discarded
	Player.move_and_slide(Player.speed, NORMAL)

func input(_Machine : Node, _Player: KinematicBody2D, event : InputEvent) -> void:

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
				if Input.is_action_pressed("hero_right"):
					direction = RIGHT
				else:
					direction = NONE

		RIGHT:
			if event.is_action_pressed("hero_left"):
				direction = LEFT

			elif event.is_action_released("hero_right"):
				if Input.is_action_pressed("hero_left"):
					direction = LEFT
				else:
					direction = NONE
