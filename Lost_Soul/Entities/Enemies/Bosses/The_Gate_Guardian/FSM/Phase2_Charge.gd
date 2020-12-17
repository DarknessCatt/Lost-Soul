extends State

var attack_position : Vector2

#Movement Speed
const NORMAL : Vector2 = Vector2(0, -1)
var speed : Vector2 = Vector2(0,0)
const ACCEL : int = 1000
const MAX_SPEED : int = 700
const FRICTION : float = 0.7

#Mini FSM
enum {CHARGE, LOOP, OUTRO}
#Atk_Laser_Animations Change this value
export(int, "CHARGE", "LOOP", "OUTRO") var state : int = CHARGE

#Loop Timers
const LOOP_TIMEOUT : float = 3.0
const LASER_TIMEOUT : float = 0.05

var loop_counter : float = 0.0
var laser_counter : float = 0.0

func enter(Guardian: KinematicBody2D) -> void:
	state = CHARGE

	speed.x = 0
	speed.y = 0

	loop_counter = 0.0
	laser_counter = 0.0

	var player_pos = Guardian.hero.global_position.x - Guardian.get_parent().global_position.x

	attack_position.y = Guardian.downwards_space

	if player_pos > 0:
		attack_position.x = -Guardian.horizontal_space
		Guardian.body.rotation = 0

	else:
		attack_position.x = Guardian.horizontal_space
		Guardian.body.rotation = 3.14

	attack_position *= 1.2

	Guardian.animation.travel("Atk_Laser_Charge")

func update(Guardian: KinematicBody2D, delta : float) -> void:

	if state == CHARGE:
		var move_dir : Vector2 = attack_position - Guardian.position

		speed += move_dir*ACCEL*delta

		if sign(speed.x) != sign(move_dir.x) : speed.x *= FRICTION
		if sign(speed.y) != sign(move_dir.y) : speed.y *= FRICTION

		speed = speed.clamped(MAX_SPEED)

		# warning-ignore:return_value_discarded
		Guardian.move_and_slide(speed, NORMAL)

	elif state == LOOP:
		loop_counter += delta
		laser_counter += delta

		while laser_counter >= LASER_TIMEOUT:
			laser_counter -= LASER_TIMEOUT
			Guardian.laser_shot()

		if loop_counter >= LOOP_TIMEOUT:
			Guardian.animation.travel("Atk_Bounce_Outro")
			state = OUTRO
			Guardian.body.rotation = 0

	else:
		# warning-ignore:return_value_discarded
		Guardian.move_and_slide(Vector2(0,-10), NORMAL)
