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
	Wanderer.speed.y = 100

# warning-ignore:narrowing_conversion
	dir = sign(Wanderer.speed.x)
	if dir == 0: dir = 1
	Wanderer.body.scale.x = dir

	path_checker.position.x = path_checker_dist*dir
	path_checker.enabled = true

func exit(_Wanderer : KinematicBody2D) -> void:
	path_checker.enabled = false

func update(Wanderer: KinematicBody2D, delta : float) -> void:
	var spdx : float = Wanderer.speed.x + dir*ACCEL*delta

	if sign(spdx) != dir : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED:
		# warning-ignore:integer_division
		if abs(spdx) - MAX_SPEED < ACCEL/10 : spdx = MAX_SPEED*dir
		else : spdx *= FRICTION

	# warning-ignore:integer_division
	elif abs(spdx) < ACCEL/100: spdx = 0

	if sign(spdx) != sign(Wanderer.speed.x) and sign(spdx) != 0:
		Wanderer.body.scale.x = sign(spdx)

	Wanderer.speed.x = spdx

	# warning-ignore:return_value_discarded
	Wanderer.move_and_slide(Wanderer.speed, NORMAL, true, 2)

	if not Wanderer.is_on_floor():
		Wanderer._change_state($"../Falling")

	elif Wanderer.is_on_wall():
		Wanderer.speed.x = 0
		self.change_direction()

	elif path_checker.get_collider() == null:
		self.change_direction()

	else:
		Wanderer.align_floor(path_checker)

func change_direction() -> void:
	dir *= -1
	path_checker.position.x *= -1
