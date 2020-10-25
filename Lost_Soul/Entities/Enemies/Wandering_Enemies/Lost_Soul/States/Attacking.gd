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
func enter(Lost_Soul : KinematicBody2D) -> void:
	Lost_Soul.change_animation("attack_begin")
	Lost_Soul.speed.y = 100

	path_checker.enabled = true
	eyes.monitoring = true

	dir = sign(Lost_Soul.body.scale.x)

	state = BEGIN

func exit(Lost_Soul : KinematicBody2D) -> void:
	path_checker.enabled = false
	eyes.monitoring = false

func update(Lost_Soul: KinematicBody2D, _delta : float) -> void:
	if state == FINISHED:
		Lost_Soul._change_state($"../Walking")

	else:
		if state == LEFT:
			Lost_Soul.change_animation("attack_end")
			state = ENDING

		var spdx : float = Lost_Soul.speed.x + dir*ACCEL*_delta

		if abs(spdx) > MAX_SPEED:
			if abs(spdx) - MAX_SPEED < ACCEL/10 : spdx = MAX_SPEED*dir
			else : spdx *= FRICTION

		Lost_Soul.speed.x = spdx

		if path_checker.get_collider() != null:
			Lost_Soul.align_floor(path_checker)

			Lost_Soul.move_and_slide(Lost_Soul.speed, NORMAL, true, 2)

			if not Lost_Soul.is_on_floor():
				Lost_Soul._change_state($"../Falling")

func _on_Enemy_Left(_body):
	state = LEFT

func _on_animation_finished(_anim_name):
	if state == ENDING:
		state = FINISHED
