extends "EnemyState.gd"

var attack_ended : bool = false

#Movement
const NORMAL : Vector2 = Vector2(0, -1)

const GRAV : int = 3500
const MAX_GRAV : int = 1500

const FRICTION : float = 0.7

#Moving Attacks
var attack_dir : float = 0.0
var speed : Vector2 = Vector2(0, 10)

func impulse(direction : Vector2):
	self.speed = Vector2(direction.x*attack_dir, direction.y)

func enter(Enemy : KinematicBody2D) -> void:
	Enemy.speed = Vector2(0,0)
	self.speed = Vector2(0,0)
	attack_ended = false

	attack_dir = Enemy.body.scale.x

	if rand_range(0,1) < 0.60:
		Enemy._change_anim("Jab")
		$Jab.start()
	else:
		Enemy._change_anim("UpTilt")
		$UpTilt.start()

func exit(_Enemy : KinematicBody2D) -> void:
	_Enemy._clear_attack_polys()
	_Enemy._disable_hitboxes()

func update(_Enemy: KinematicBody2D, delta : float) -> void:

	if attack_ended:
		_Enemy._change_state($"../OnCombat")

	if speed.x != 0:
		speed.x *= FRICTION
		if abs(speed.x) < 10 : speed.x = 0

	_Enemy.move_and_slide(speed, NORMAL)

	if _Enemy.is_on_floor():
		speed.y = 10

	else:
		speed.y += GRAV*delta
		if speed.y > MAX_GRAV: speed.y = MAX_GRAV

func _on_Attack_timeout():
	attack_ended = true
