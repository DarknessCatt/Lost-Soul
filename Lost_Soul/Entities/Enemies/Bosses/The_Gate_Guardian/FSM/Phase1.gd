extends State

export(int) var horizontal_space = 0
export(int) var downwards_space = 0

#Attributes
const MAX_HEALTH : int = 80
var health : int = MAX_HEALTH
var animation : AnimationNodeStateMachinePlayback
var effects : AnimationPlayer

#Side Switch Info
const SIDE_SWITCH_THRESHOLD : int = 20
var side_damage : int = 0

#Movement Speed
const NORMAL : Vector2 = Vector2(0, -1)
var speed : Vector2 = Vector2(0,0)
const ACCEL : int = 500
const MAX_SPEED : int = 500
const FRICTION : float = 0.95

#Movement Direction
var point_to_seek : Vector2 = Vector2(0,0)
var seek_timer : float = 0.0
const seek_variance : float = 20.0
const seek_cooldown : float = 1.0

#Attack Timer
var atk_timer : float = 0.0
const atk_variance : float = 1.0
const atk_base_cooldown : float = 5.0
var atk_cooldown : float = 0.0

func enter(Guardian : KinematicBody2D) -> void:
	animation = Guardian.animation
	effects = Guardian.effects
	randomize()
	point_to_seek = Vector2(horizontal_space, downwards_space)
	atk_cooldown = atk_base_cooldown \
					+ rand_range(-atk_variance, atk_variance)

func update(Guardian: KinematicBody2D, delta : float) -> void:

	#Handling Body Rotation
	var look_dir : Vector2 = Guardian.hero.global_position \
						- Guardian.global_position

	Guardian.body.rotation = look_dir.angle()

	#Handling point_to_seek
	seek_timer += delta

	if seek_timer >= seek_cooldown:
		seek_timer = 0.0
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

	#Handling Attacks
	atk_timer += delta

	if atk_timer > atk_cooldown:
		atk_timer = 0.0
		atk_cooldown = atk_base_cooldown \
						+ rand_range(-atk_variance, atk_variance)

		if rand_range(0, 1) <= 0.5:
			animation.travel("Atk_Shoot_Multi")

		else:
			animation.travel("Atk_Shoot_Spread")

func hit(damage : int, force : int, direction : Vector2) -> void:
	health -= damage
	side_damage += damage

	speed += force*direction.normalized()

	if side_damage >= SIDE_SWITCH_THRESHOLD:
		side_damage = 0
		point_to_seek.x = -1*sign(point_to_seek.x)*horizontal_space
		point_to_seek.y = downwards_space
		animation.travel("Side_Switch")
		speed.x = MAX_SPEED*4*sign(point_to_seek.x)

	else:
		effects.play("hit")
