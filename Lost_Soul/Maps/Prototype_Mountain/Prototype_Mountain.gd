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

var attack_dialogue : Array = ["Teu corpo ainda\nesta fraco.",
							  "Eu irei te\nconceder um pouco\ndo meu poder.",
							  ""]

func _on_Attacking_Tutorial_entered(area):
	$Hero/Camera2D/Chaos.change_dialogue(attack_dialogue)
	$Hero/Camera2D/Chaos.begin()
	$Events/Attacking_Tutorial.call_deferred("set", "monitoring", false)
	$Cutscene.play("Attack_Tutorial")

var checkpoint_dialogue : Array = ["Ha um altar\nproximo.",
								 "Encoste nele...",
								 "Eu posso manipular\nas suas energias.",
								 ""]

func _on_Checkpoint_Tutorial_entered(body):
	$Hero/Camera2D/Chaos.change_dialogue(checkpoint_dialogue)
	$Hero/Camera2D/Chaos.begin()
	$Events/Checkpoint_Tutorial.call_deferred("set", "monitoring", false)
