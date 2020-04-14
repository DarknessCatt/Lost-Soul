extends Node2D

onready var respawn_point : Vector2 = $Hero.global_position
onready var hero : KinematicBody2D = $Hero

func _hero_died():
	hero._die()
	$respawn_timer.start()

func respawn():
	hero.health = 1
	hero.global_position = respawn_point
	hero.on_cutscene = false

func _on_Checkpoint_checkpoint_reached(checkpoint : Area2D):
	respawn_point = checkpoint.global_position
	for enemy in $Enemies.get_children():
		enemy._respawn()
	$Hazards/Arena._restart()
