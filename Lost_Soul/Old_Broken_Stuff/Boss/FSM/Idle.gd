extends "EnemyState.gd"

func enter(Enemy : KinematicBody2D) -> void:
	Enemy._change_anim("Idle")

func update(Enemy : KinematicBody2D, _delta : float) -> void:
	if Enemy.Player != null:
		Enemy._change_state($"../OnCombat")
