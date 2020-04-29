extends "res://Classes/State.gd"

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
func enter(_Player : KinematicBody2D) -> void:
	_Player.change_animation(state_anim)
	_Player.speed.y = 10

	dir = sign(_Player.speed.x)
	if dir == 0: dir = 1

	path_checker.position.x = path_checker_dist*dir
	path_checker.enabled = true

func exit(_Player : KinematicBody2D) -> void:
	path_checker.enabled = false

func update(_Player: KinematicBody2D, _delta : float) -> void:
	var spdx : float = _Player.speed.x + dir*ACCEL*_delta

	if sign(spdx) != dir : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED: spdx = MAX_SPEED*dir
	elif abs(spdx) < 10: spdx = 0

	if sign(spdx) != sign(_Player.speed.x):
		match sign(spdx):
			-1.0:
				_Player.body.scale.x = -1
			1.0:
				_Player.body.scale.x = 1

	_Player.speed.x = spdx

	_Player.move_and_slide(_Player.speed, NORMAL)

	if not _Player.is_on_floor():
		_Player._change_state($"../Falling")

	if _Player.is_on_wall():
		_Player.speed.x = 0
		self.change_direction()

	if path_checker.get_collider() == null:
		self.change_direction()

func change_direction() -> void:
	dir *= -1
	path_checker.position.x *= -1
