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

var attack_dialogue : Array = ["Teu corpo ainda\nestá fraco.",
							  "Eu irei te\nconceder um pouco\ndo meu poder.",
							  ""]

func _on_Attacking_Tutorial_entered(_body):
	$Hero/Camera2D/Chaos.change_dialogue(attack_dialogue)
	$Hero/Camera2D/Chaos.begin()
	$Events/Attacking_Tutorial.call_deferred("set", "monitoring", false)
	$Cutscene.play("Attack_Tutorial")

var checkpoint_dialogue : Array = ["Há um altar\npróximo.",
								 "Encoste nele...",
								 "Eu posso manipular\nas suas energias.",
								 ""]

func _on_Checkpoint_Tutorial_entered(_body):
	$Hero/Camera2D/Chaos.change_dialogue(checkpoint_dialogue)
	$Hero/Camera2D/Chaos.begin()
	$Events/Checkpoint_Tutorial.call_deferred("set", "monitoring", false)

var heart_dialogue : Array = ["             ",
						  "Impressionante...",
						  "Um coração\nde cristal...",
						  "Consuma suas energias,\n revigore tua alma.",
						  ""]

func _on_Crystal_Heart_collected(_body):
	$Hero/Camera2D/Chaos.change_dialogue(heart_dialogue)
	$Hero/Camera2D/Chaos.begin()
	$Cutscene.play("Crystal_Tutorial")

var ending_dialogue : Array = ["...",
							 "Muito bem,",
							 "fostes muito bem,",
							 "Mas temos muito\no que fazer ainda...",
							 "Este mundo\nserá meu.",
							 "E tu me\najudaras,",
							 "minha cara,",
							 "Alma\nPerdida                                    \nPrototipo 1\n\nObrigado por jogar!"]

func _on_Ending(_body):
	$Hero/Camera2D/Chaos.change_dialogue(ending_dialogue)
	$Hero/Camera2D/Chaos.begin()
	$Cutscene.play("Ending")
