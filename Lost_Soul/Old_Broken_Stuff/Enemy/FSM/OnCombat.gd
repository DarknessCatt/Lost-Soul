extends "EnemyState.gd"

#Player Info
var player_in_range : bool = false

#Movement
const NORMAL : Vector2 = Vector2(0, -1)

const GRAV : int = 3500
const MAX_GRAV : int = 1500

const ACCEL : int = 900
const MAX_SPEED : int = 500
const FRICTION : float = 0.8

#Combat
var min_dist : int
var max_dist : int
var attack_dist : int
var attack_timer : float

var attack_ready : bool = false

##Functions
func _on_Attack_Ready():
	attack_ready = true

#Direction
enum {LEFT = -1, NONE, RIGHT}
var direction : int = NONE

func enter(Enemy : KinematicBody2D) -> void:
	min_dist = 130 + int(rand_range(-10,+40))
	max_dist = 180 + int(rand_range(-20,+20))
	attack_dist = 200 + int(rand_range(-10,+10))

	if Enemy.speed.x == 0:
		Enemy._change_anim("OnCombat")
	else:
		Enemy._change_anim("Walking")

	$Attack_Timer.wait_time = 0.7 + rand_range(-0.5, +0.5)
	$Attack_Timer.start()

func exit(_Enemy : KinematicBody2D) -> void:
	$Attack_Timer.stop()

func update(_Enemy : KinematicBody2D, delta : float) -> void:

	var player_dist = (_Enemy.Player.position - _Enemy.position).x

	if abs(player_dist) <= min_dist: player_in_range = true
	elif abs(player_dist) >= max_dist: player_in_range = false

	var spdx : float = _Enemy.speed.x

	if player_in_range and sign(player_dist) == sign(_Enemy.body.scale.x):
		direction = NONE

	else:
		direction = sign(player_dist)
		spdx += direction*ACCEL*delta

	if sign(spdx) != direction : spdx *= FRICTION

	if abs(spdx) > MAX_SPEED: spdx = MAX_SPEED*direction
	elif abs(spdx) < 4: spdx = 0

	if sign(spdx) != sign(_Enemy.speed.x):
		match sign(spdx):
			-1.0:
				_Enemy.body.scale.x = -1
				_Enemy._change_anim("Walking")
			0.0:
				_Enemy._change_anim("OnCombat")
			1.0:
				_Enemy.body.scale.x = 1
				_Enemy._change_anim("Walking")

	_Enemy.speed.x = spdx

	if _Enemy.is_on_floor():
		_Enemy.speed.y = 10

	else:
		_Enemy.speed.y += GRAV*delta
		if _Enemy.speed.y > MAX_GRAV: _Enemy.speed.y = MAX_GRAV

	_Enemy.move_and_slide(_Enemy.speed, NORMAL)

	if attack_ready and abs(player_dist) <= attack_dist:
		attack_ready = false
		_Enemy._change_state($"../Attack")

