extends State

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
export(int) var ACCEL : int = 2000
export(int) var MAX_SPEED : int = 100
export(float) var FRICTION : float = 0.75
var dir : int = 1
onready var path_checker : RayCast2D = $"../../Perception/Path_Checker"
onready var eyes : Area2D = $"../../Perception/Eyes"

enum {BEGIN, LEFT, ENDING, FINISHED}

var state : int = BEGIN

#Functions
func enter(_Player : KinematicBody2D) -> void:
	_Player.change_animation("attack_begin")
	_Player.speed.y = 10

	path_checker.enabled = true
	eyes.monitoring = true

	dir = sign(_Player.body.scale.x)

	state = BEGIN

func exit(_Player : KinematicBody2D) -> void:
	path_checker.enabled = false
	eyes.monitoring = false

func update(_Player: KinematicBody2D, _delta : float) -> void:
	if state == FINISHED:
		_Player._change_state($"../Walking")

	else:
		if state == LEFT:
			_Player.change_animation("attack_end")
			state = ENDING

		var spdx : float = _Player.speed.x + dir*ACCEL*_delta

		if abs(spdx) > MAX_SPEED:
			if abs(spdx) - MAX_SPEED < ACCEL/10 : spdx = MAX_SPEED*dir
			else : spdx *= FRICTION

		_Player.speed.x = spdx

		if path_checker.get_collider() != null:
			_Player.move_and_slide(_Player.speed, NORMAL)

		if not _Player.is_on_floor():
			_Player._change_state($"../Falling")

func _on_Enemy_Left(_body):
	state = LEFT

func _on_animation_finished(_anim_name):
	if state == ENDING:
		state = FINISHED
