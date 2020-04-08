extends "EnemyState.gd"

func update(Enemy : KinematicBody2D, _delta : float) -> void:
	if Enemy.Player != null:
		Enemy._change_state($"../OnCombat")
