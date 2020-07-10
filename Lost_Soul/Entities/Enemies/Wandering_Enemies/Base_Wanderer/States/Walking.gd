extends State

#State info
export(String) var state_anim : String = "Walking"
export(int) var path_checker_dist : int = 0

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
export(int) var ACCEL : int = 2000
export(int) var MAX_SPEED : int = 100
export(float) var FRICTION : float = 0.75
var dir : int = 1
onready var path_checker : RayCast2D = $"../../Perception/Path_Checker"

#Functions
func enter(Wanderer : KinematicBody2D) -> void:
	Wanderer.change_animation(state_anim)
	Wanderer.speed.y = 10

	dir = sign(Wanderer.speed.x)
	if dir == 0: dir = 1

	match sign(dir):
		-1.0:
			Wanderer.body.scale.x = -1
		1.0:
			Wanderer.body.scale.x = 1

	path_checker.position.x = path_checker_dist*dir
	path_checker.enabled = true

func exit(Wanderer : KinematicBody2D) -> void:
	path_checker.enabled = false

func update(Wanderer: KinematicBody2D, delta : float) -> void:
	var spdx : float = Wanderer.speed.x + dir*ACCEL*delta

	if sign(spdx) != dir : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED:
		if abs(spdx) - MAX_SPEED < ACCEL/10 : spdx = MAX_SPEED*dir
		else : spdx *= FRICTION

	elif abs(spdx) < ACCEL/100: spdx = 0

	if sign(spdx) != sign(Wanderer.speed.x):
		match sign(spdx):
			-1.0:
				Wanderer.body.scale.x = -1
			1.0:
				Wanderer.body.scale.x = 1

	Wanderer.speed.x = spdx

	Wanderer.move_and_slide(Wanderer.speed, NORMAL)

	if not Wanderer.is_on_floor():
		Wanderer._change_state($"../Falling")

	elif path_checker.get_collider() == null:
		self.change_direction()

	elif Wanderer.is_on_wall():
		Wanderer.speed.x = 0
		self.change_direction()

func change_direction() -> void:
	dir *= -1
	path_checker.position.x *= -1
