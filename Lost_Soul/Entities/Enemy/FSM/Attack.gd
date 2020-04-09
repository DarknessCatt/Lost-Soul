extends "EnemyState.gd"

var attack_ended : bool = false

func enter(Enemy : KinematicBody2D) -> void:
	Enemy.speed = Vector2(0,0)
	attack_ended = false

	Enemy._change_anim("Jab")
	$Jab.start()

func update(Enemy: KinematicBody2D, _delta : float) -> void:
	if attack_ended:
		Enemy._change_state($"../OnCombat")

func exit(_Enemy : KinematicBody2D) -> void:
	_Enemy._clear_attack_polys()

func _on_Attack_timeout():
	attack_ended = true
