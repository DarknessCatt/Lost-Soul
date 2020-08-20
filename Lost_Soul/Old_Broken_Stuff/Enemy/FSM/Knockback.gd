extends "EnemyState.gd"

const NORMAL : Vector2 = Vector2(0, -1)

const GRAV : int = 3500
const MAX_GRAV : int = 1500
const FRICTION : float = 0.9

const FALL_DELAY : float = 0.06
const DOWN_THRESHOLD : int = 1000

#Mini FSM
enum {SIMPLE, ASCENDING, FLOATING, FALLING, DOWN, DONE}
var state : int

var delay_counter : float = 0.0

func enter(Enemy : KinematicBody2D) -> void:

	if Enemy.speed.y < 0: 		state = ASCENDING
	elif Enemy.is_on_floor(): 	state = SIMPLE
	else: 					 	state = FLOATING

	delay_counter = 0.0
	Enemy._change_anim("OnHit")

func exit(_Enemy : KinematicBody2D) -> void:
	pass

func update(Enemy: KinematicBody2D, delta : float) -> void:
	if state == DONE:
		Enemy._change_state($"../OnCombat")

	else:
		var spd : Vector2 = Enemy.speed

		if state == SIMPLE or state == DOWN:
			spd.x *= FRICTION

		elif state == FLOATING:
			delay_counter += delta

			if delay_counter > FALL_DELAY:
				state = FALLING

		else:
			spd.y += GRAV*delta
			if spd.y > MAX_GRAV: spd.y = MAX_GRAV

			if state == ASCENDING and spd.y > 0:
				spd.y = 0
				state = FLOATING

		Enemy.speed = spd

		Enemy.move_and_slide(Enemy.speed, NORMAL)

		if Enemy.is_on_wall():
			Enemy.speed.x *= -0.2

		if state == FALLING and Enemy.is_on_floor():
			if spd.length() >= DOWN_THRESHOLD:
				state = DOWN
				Enemy._change_anim("OnFallenDown")
			else:
				state = DONE

func _anim_done():
	if state == SIMPLE or state == DOWN:
		state = DONE
