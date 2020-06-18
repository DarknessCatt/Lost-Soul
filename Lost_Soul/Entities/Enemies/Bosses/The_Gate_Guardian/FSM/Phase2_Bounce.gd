extends State

#Movement Speed
const NORMAL : Vector2 = Vector2(0, -1)
var speed : Vector2 = Vector2(0,0)
const ACCEL : int = 300
const MAX_SPEED : int = 700
const FRICTION : float = 0.9

func enter(Guardian: KinematicBody2D) -> void:
	speed.x = 0
	speed.y = -700

	Guardian.animation.travel("Atk_Bounce_Intro")

func update(Guardian: KinematicBody2D, delta : float) -> void:

	var move_dir : float = Guardian.hero.global_position.x \
							- Guardian.global_position.x

	speed.x += (move_dir/500)*ACCEL*delta

	speed.x = min(speed.x, MAX_SPEED)

	Guardian.move_and_slide(speed, NORMAL)

	Guardian.body.rotation = speed.angle() - 1.57 #90 deg in rad

	if Guardian.is_on_floor() or Guardian.is_on_ceiling():
		speed.y *= -1

	if Guardian.is_on_wall():
		speed.x *= -0.5
