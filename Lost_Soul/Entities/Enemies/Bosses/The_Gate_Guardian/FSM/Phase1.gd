extends State

export(int) var horizontal_space = 0
export(int) var downwards_space = 0

#Movement Speed
const NORMAL : Vector2 = Vector2(0, -1)
var speed : Vector2 = Vector2(0,0)
const ACCEL : int = 500
const MAX_SPEED : int = 500
const FRICTION : float = 0.9

#Movement Direction
var point_to_seek : Vector2 = Vector2(0,0)
var seek_timer : float = 0.0
const seek_variance : float = 20.0
const seek_cooldown = 1

func enter(_Guardian : KinematicBody2D) -> void:
	point_to_seek = Vector2(horizontal_space, downwards_space)

func update(Guardian: KinematicBody2D, delta : float) -> void:

	#Handling Body Rotation
	var look_dir : Vector2 = Guardian.hero.global_position \
						- Guardian.global_position

	Guardian.body.rotation = look_dir.angle()

	#Handling point_to_seek
	seek_timer += delta

	if seek_timer >= seek_cooldown:
		seek_timer = 0
		point_to_seek.x += rand_range(-seek_variance, seek_variance)
		point_to_seek.y += rand_range(-seek_variance, seek_variance)

	#Handling Movement
	var move_dir : Vector2 = (point_to_seek - Guardian.position)

	speed += move_dir.normalized()*ACCEL*delta

	if sign(speed.x) != sign(move_dir.x) : speed.x *= FRICTION
	if sign(speed.y) != sign(move_dir.y) : speed.y *= FRICTION

	if speed.length() > MAX_SPEED:
		if speed.length() - MAX_SPEED < ACCEL/10: speed = MAX_SPEED*speed.normalized()
		else: speed *= FRICTION

	else:
		if abs(speed.x) < 1: speed.x = 0
		if abs(speed.y) < 1: speed.y = 0

	Guardian.move_and_slide(speed, NORMAL)
