extends Node2D

onready var respawn_point : Vector2 = $Hero.position
onready var hero : KinematicBody2D = $Hero

func _hero_died():
	hero._die()
	$respawn_timer.start()

func respawn():
	hero.health = 1
	hero.position = respawn_point
	hero.on_cutscene = false
