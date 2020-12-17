extends State

#State info
var hero : KinematicBody2D
onready var eyes : RayCast2D = $"../../Perception/Eyes"

#Mini FSM
var detected : bool = false

#Movement
const NORMAL : Vector2 = Vector2(0, -1)
const ACCEL : int = 400
const MAX_SPEED : int = 300

var dir : int = 0

#Functions
func enter(Hawk : KinematicBody2D) -> void:
	Hawk.change_animation("Flying")
	Hawk.hero = null
	# warning-ignore:narrowing_conversion
	dir = sign(Hawk.speed.x)
	# warning-ignore:narrowing_conversion
	if dir == 0: dir = sign(Hawk.body.scale.x)

	Hawk.body.scale.x = dir

func update(Hawk: KinematicBody2D, delta : float) -> void:
	if detected and Hawk.can_attack:
		eyes.cast_to = (hero.global_position - eyes.global_position)
		eyes.force_raycast_update()
		if eyes.get_collider() == null:
			Hawk.hero = hero
			Hawk._change_state($"../Flying")

	var spd_x = Hawk.speed.x + (ACCEL*delta*dir)

	if abs(spd_x) > MAX_SPEED: spd_x = MAX_SPEED*dir

	Hawk.speed.x = spd_x

	if abs(Hawk.position.y - Hawk.original_position.y) > 10:
		Hawk.speed.y = (Hawk.original_position.y - Hawk.position.y)*ACCEL*0.1*delta

	else:
		Hawk.speed.y = 0

	# warning-ignore:return_value_discarded
	Hawk.move_and_slide(Hawk.speed, NORMAL)

	if Hawk.is_on_wall():
		dir *= -1
		Hawk.body.scale.x = dir
		Hawk.speed.x = 0
		detected = false

func _on_Player_Detected(body):
	if rand_range(0, 1) <= 0.5:
		hero = body
		detected = true

func _on_Player_Exited(_body):
	detected = false
