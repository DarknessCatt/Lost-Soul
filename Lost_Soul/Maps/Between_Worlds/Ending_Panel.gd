extends Node2D

var Player : KinematicBody2D = null
onready var panel : Panel = $Panel

func _on_Active_Area_body_entered(body):
	Player = body

func _on_Active_Area_body_exited(_body):
	Player = null

func _process(_delta):
	if Player != null:
		var rel_pos = Player.position - self.position
		var modulate_val = min(1, rel_pos.x/1800)
		Player.get_node("Player_Camera").modulate.a = 1 - modulate_val
		panel.modulate.a = modulate_val
