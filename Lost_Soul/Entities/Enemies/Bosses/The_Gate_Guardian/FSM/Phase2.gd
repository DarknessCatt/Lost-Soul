extends State

var horizontal_space = 0
var downwards_space = 0

#Attributes
const MAX_HEALTH : int = 45
var health : int = MAX_HEALTH
var animation : AnimationNodeStateMachinePlayback
var effects : AnimationPlayer
var Guardian_Node : KinematicBody2D

#Movement Speed
const NORMAL : Vector2 = Vector2(0, -1)
var speed : Vector2 = Vector2(0,0)
const ACCEL : int = 300
const MAX_SPEED : int = 500
const FRICTION : float = 0.95

#Movement Direction
var point_to_seek : Vector2 = Vector2(0,-20)
var seek_timer : float = 0.0
const seek_variance : float = 5.0
const seek_cooldown : float = 0.5

#Attack Timer
var atk_timer : float = 0.0
const atk_variance : float = 0.0
const atk_base_cooldown : float = 5.0
var atk_cooldown : float = 0.0

#"FSM"
var on_bounce : bool = false
var atk_counter : int = 0

func enter(Guardian : KinematicBody2D) -> void:
	health = MAX_HEALTH
	speed = Vector2(0,0)
	on_bounce = false
	atk_timer = 0
	atk_counter = 0
	Guardian_Node = Guardian

	animation = Guardian.animation
	effects = Guardian.effects
	horizontal_space = Guardian.horizontal_space
	downwards_space = Guardian.downwards_space

	point_to_seek = Vector2(horizontal_space, 0)
	atk_cooldown = atk_base_cooldown \
					+ rand_range(-atk_variance, atk_variance)

func exit(Guardian : KinematicBody2D) -> void:
	Guardian.body.rotation = 0

func update(Guardian: KinematicBody2D, delta : float) -> void:

	if health <= 0 and animation.get_current_node() == "Idle_2":
		Guardian._change_state($"../Dead")

	if on_bounce:
		$Phase2_Bounce.update(Guardian, delta)
		return

	#Handling Body Rotation
	var look_dir : Vector2 = Guardian.hero.global_position \
						- Guardian.global_position

	Guardian.body.rotation = look_dir.angle() - 1.57 #90 deg in rad

	#Handling point_to_seek
	seek_timer += delta

	if seek_timer >= seek_cooldown:
		seek_timer = 0.0
		point_to_seek.y = rand_range(-seek_variance, seek_variance)

	var move_dir : Vector2 = (point_to_seek - Guardian.position)

	if abs(move_dir.x) < seek_variance:
		point_to_seek.x *= -1

	#Handling Movement
	speed += move_dir.normalized()*ACCEL*delta

	if sign(speed.x) != sign(move_dir.x) : speed.x *= FRICTION
	if sign(speed.y) != sign(move_dir.y) : speed.y *= FRICTION

	if speed.length() > MAX_SPEED:
		# warning-ignore:integer_division
		if speed.length() - MAX_SPEED < ACCEL/10: speed = MAX_SPEED*speed.normalized()
		else: speed *= FRICTION

	else:
		if abs(speed.x) < 1: speed.x = 0
		if abs(speed.y) < 1: speed.y = 0

	# warning-ignore:return_value_discarded
	Guardian.move_and_slide(speed, NORMAL)

	#Handling Attacks
	atk_timer += delta

	if atk_timer > atk_cooldown:
		atk_timer = 0.0
		atk_cooldown = atk_base_cooldown \
						+ rand_range(-atk_variance, atk_variance)

		atk_counter += 1

		if atk_counter < 3:
			animation.travel("Atk_Shoot_Rain")

		else:
			atk_counter = 0
			$Phase2_Bounce.enter(Guardian)
			on_bounce = true

func hit(damage : int, force : int, direction : Vector2) -> void:
	health -= damage

	speed += (force/1.5)*direction.normalized()

	effects.play("hit")

# Called by Atk_Bounce_Outro

func bounce_end() -> void:
	on_bounce = false
	speed = Vector2(0,-1)*MAX_SPEED
	point_to_seek = sign(Guardian_Node.position.x)*Vector2(horizontal_space, 0)
