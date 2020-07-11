extends State

#Movement Speed
const NORMAL : Vector2 = Vector2(0, -1)
var speed : Vector2 = Vector2(0,0)
const ACCEL : int = 3
const MAX_SPEED : int = 600
const FRICTION : float = 0.9

#Mini FSM
enum {INTRO, BOUNCE, OUTRO}
var state : int = INTRO
var floor_bounce : int = 0

func enter(Guardian: KinematicBody2D) -> void:
	state = INTRO

	speed.x = 0
	speed.y = 0

	Guardian.animation.travel("Atk_Bounce_Intro")

func update(Guardian: KinematicBody2D, delta : float) -> void:

	if state == BOUNCE:
		var move_dir : float = Guardian.hero.global_position.x \
								- Guardian.global_position.x

		speed.x += move_dir*ACCEL*delta

		if sign(speed.x) != sign(move_dir) : speed.x *= FRICTION

		speed.x = sign(speed.x)*min(abs(speed.x), MAX_SPEED)

		Guardian.move_and_slide(speed, NORMAL)

		Guardian.body.rotation = speed.angle() - 1.57 #90 deg in rad

		if Guardian.is_on_floor() or Guardian.is_on_ceiling():
			Guardian.get_node("Wall").play(0.17)
			speed.y *= -1

			if Guardian.is_on_floor():
				floor_bounce += 1

				if floor_bounce >= 8:
					Guardian.animation.travel("Atk_Bounce_Outro")
					state = OUTRO
					Guardian.body.rotation = 0

		if Guardian.is_on_wall():
			Guardian.get_node("Wall").play(0.17)
			speed.x *= -0.5

	elif state == INTRO:
		var move_dir : Vector2 = Guardian.hero.global_position \
					- Guardian.global_position

		speed -= move_dir.normalized()*(ACCEL*20)*delta

		Guardian.move_and_slide(speed, NORMAL)

		Guardian.body.rotation = move_dir.angle() - 1.57

	else:
		Guardian.move_and_slide(Vector2(0,-25), NORMAL)

# Called by Atk_Bounce_Intro / Outro

func begin_bounce() -> void:
	state = BOUNCE
	speed.x *= -1
	speed.y = 1200
	floor_bounce = 0
