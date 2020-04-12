extends "State.gd"

const NORMAL : Vector2 = Vector2(0, -1)

const GRAV : int = 3500
const MAX_GRAV : int = 1500
const FRICTION : float = 0.9

const FALL_DELAY : float = 0.06
const DOWN_THRESHOLD : int = 500

#Mini FSM
enum {SIMPLE, FALLING, DOWN, DONE}
var state : int

var delay_counter : float = 0.0

func enter(_Player : KinematicBody2D) -> void:
	_Player.invencible = true

	if _Player.speed.y < 0 or not _Player.is_on_floor():
		state = FALLING
	else:
		state = SIMPLE

	_Player._change_anim("OnHit")

func exit(_Player: KinematicBody2D) -> void:
	_Player.invencible = false
	_Player.speed = Vector2(0,0)

func update(_Player: KinematicBody2D, delta : float) -> void:
	if state == DONE:
		_Player._change_state($"../OnGround")

	else:
		var spd : Vector2 = _Player.speed

		if state == SIMPLE or state == DOWN:
			spd.x *= FRICTION

		else:
			spd.y += GRAV*delta
			if spd.y > MAX_GRAV: spd.y = MAX_GRAV

		_Player.speed = spd

		_Player.move_and_slide(_Player.speed, NORMAL)

		if _Player.is_on_wall():
			_Player.speed.x *= -0.2

		if state == FALLING and _Player.is_on_floor():
			if spd.length() >= DOWN_THRESHOLD:
				state = DOWN
				_Player._change_anim("OnFallenDown")
			else:
				state = DONE

func _anim_done():
	if state == SIMPLE or state == DOWN:
		state = DONE
