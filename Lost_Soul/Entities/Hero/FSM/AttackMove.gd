extends State

const NORMAL : Vector2 = Vector2(0, -1)

##Movement Vars
const ACCEL : int = 2000
const MAX_SPEED : int = 400
const FRICTION : float = 0.75
const GRAV : int = 3500
const MAX_GRAV : int = 1500

onready var buffer : Node = $"../Buffer"

var attack_finished : bool = false

#Direction Enum FSM
enum {LEFT = -1, NONE, RIGHT}
var direction : int = NONE

func enter(_Player : KinematicBody2D) -> void:
	if Input.is_action_pressed("hero_left"): 	direction = LEFT
	elif Input.is_action_pressed("hero_right"): direction = RIGHT
	else: 										direction = NONE

	attack_finished = false

func exit(_Player: KinematicBody2D) -> void:
	_Player._clear_attack_polys()
	_Player._disable_hitboxes()

func update(_Player: KinematicBody2D, delta : float) -> void:
	var spdx : float = _Player.speed.x + direction*ACCEL*delta

	if _Player.is_on_floor():
		_Player.speed.y = 10

	else:
		_Player.speed.y += GRAV*delta
		if _Player.speed.y > MAX_GRAV: _Player.speed.y = MAX_GRAV

	if sign(spdx) != direction : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED: spdx = MAX_SPEED*direction
	elif abs(spdx) < 10: spdx = 0

	_Player.speed.x = spdx

	_Player.move_and_slide(_Player.speed, NORMAL)

func input(_Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action("hero_jump"):
		buffer._buffer_jump()

	elif event.is_action_pressed("hero_attack"):
		buffer._buffer_attack()

	else:
		match(direction):

			NONE:
				if event.is_action_pressed("hero_left"):
					direction = LEFT

				elif event.is_action_pressed("hero_right"):
					direction = RIGHT

			LEFT:
				if event.is_action_pressed("hero_right"):
					direction = RIGHT

				elif event.is_action_released("hero_left"):
					if Input.is_action_pressed("hero_right"):
						direction = RIGHT
					else:
						direction = NONE

			RIGHT:
				if event.is_action_pressed("hero_left"):
					direction = LEFT

				elif event.is_action_released("hero_right"):
					if Input.is_action_pressed("hero_left"):
						direction = LEFT
					else:
						direction = NONE

func _on_Attack_timeout():
	attack_finished = true
