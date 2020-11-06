extends Area2D

export(PackedScene) var checkpoint_menu : PackedScene

signal checkpoint_reached(checkpoint)
signal checkpoint_activated(checkpoint_menu)

var player_in_range : bool = false
var player : KinematicBody2D = null

func _on_Checkpoint_body_entered(body : KinematicBody2D):
	player_in_range = true
	$Close_Particles.emitting = true
	player._refresh()
	if player == null:
		player = body
		$Animation.play("Activated")
		self.emit_signal("checkpoint_reached", self)

func _on_Checkpoint_body_exited(_body):
	player_in_range = false
	$Close_Particles.emitting = false

func _input(event):
	if player_in_range and event.is_action_pressed("hero_up"):
		self.emit_signal("checkpoint_activated", checkpoint_menu)
