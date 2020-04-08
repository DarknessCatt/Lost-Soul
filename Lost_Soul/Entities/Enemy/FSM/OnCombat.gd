extends "EnemyState.gd"

#Player Info
var player_in_range : bool = false

#Movement
const NORMAL : Vector2 = Vector2(0, -1)

const ACCEL : int = 500
const MAX_SPEED : int = 500
const FRICTION : float = 0.6

#Direction
enum {LEFT = -1, NONE, RIGHT}
var direction : int = NONE

func enter(Enemy : KinematicBody2D) -> void:
	Enemy._change_anim("OnCombat")
	Enemy.speed.y = 10

func update(_Enemy : KinematicBody2D, delta : float) -> void:

	var player_dist = (_Enemy.Player.position - _Enemy.position).x

	if abs(player_dist) <= 60: player_in_range = true
	elif abs(player_dist) >= 120: player_in_range = false

	var spdx : float = _Enemy.speed.x

	if player_in_range:
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

	_Enemy.move_and_slide(_Enemy.speed, NORMAL)
