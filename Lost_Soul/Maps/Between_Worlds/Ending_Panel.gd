extends Node2D

var Player : KinematicBody2D = null
onready var panel : Panel = $Panel

func _on_Active_Area_body_entered(body):
	Player = body

func _on_Active_Area_body_exited(_body):
	Player = null

func _process(delta):
	if Player != null:
		var rel_pos = Player.position - self.position
		Player.get_node("Player_Camera").modulate.a = 1 - rel_pos.x/2000
		panel.modulate.a = rel_pos.x/2000
