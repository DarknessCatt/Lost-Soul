extends Area2D

signal checkpoint_reached(checkpoint)

var player_in_range : bool = false
var player : KinematicBody2D = null

func _on_Checkpoint_body_entered(body : KinematicBody2D):
	player_in_range = true
	player = body
	$Range.play("entered")

func _on_Checkpoint_body_exited(_body):
	player_in_range = false
	player = null
	$Range.play_backwards("entered")

func active():
	player._refresh()
	$Animation.play("Activated")
	self.emit_signal("checkpoint_reached", self)

func _input(event):
	if player_in_range and event.is_action_pressed("hero_up"):
		self.active()
