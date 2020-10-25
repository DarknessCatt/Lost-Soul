extends State

#State info
export(String) var state_anim : String = "Walking"
export(int) var path_checker_dist : int = 0
var enemy_detected : bool = false

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
export(int) var ACCEL : int = 300
export(int) var MAX_SPEED : int = 100
export(float) var FRICTION : float = 0.7
var dir : int = 1

onready var path_checker : RayCast2D = $"../../Perception/Path_Checker"
onready var eyes : Area2D = $"../../Perception/Eyes"

#Functions
func enter(Lost_Soul : KinematicBody2D) -> void:

	Lost_Soul.change_animation(state_anim)
	Lost_Soul.speed.y = 100

	dir = sign(Lost_Soul.speed.x)
	if dir == 0: dir = 1
	Lost_Soul.body.scale.x = dir

	enemy_detected = false

	path_checker.position.x = path_checker_dist*dir
	path_checker.enabled = true

	eyes.monitoring = true

func exit(_Lost_Soul : KinematicBody2D) -> void:
	path_checker.enabled = false
	eyes.monitoring = false

func update(Lost_Soul: KinematicBody2D, delta : float) -> void:
	var spdx : float = Lost_Soul.speed.x

	if abs(spdx) < MAX_SPEED: spdx += dir*ACCEL*delta

	if sign(spdx) != dir : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED:
		if abs(spdx) - MAX_SPEED < ACCEL/10 : spdx = MAX_SPEED*dir
		else : spdx *= FRICTION

	elif abs(spdx) < ACCEL/100: spdx = 0

	if sign(spdx) != sign(Lost_Soul.speed.x) and sign(spdx) != 0:
		Lost_Soul.body.scale.x = sign(spdx)

	Lost_Soul.speed.x = spdx

	Lost_Soul.move_and_slide(Lost_Soul.speed, NORMAL, true, 2)

	if not Lost_Soul.is_on_floor():
		Lost_Soul._change_state($"../Falling")

	elif enemy_detected:
		Lost_Soul._change_state($"../Attacking")

	elif Lost_Soul.is_on_wall():
		Lost_Soul.speed.x = 0
		self.change_direction()

	elif path_checker.get_collider() == null:
		self.change_direction()

	else:
		Lost_Soul.align_floor(path_checker)

func change_direction() -> void:
	dir *= -1
	path_checker.position.x *= -1

func _on_Enemy_detected(_body):
	enemy_detected = true
