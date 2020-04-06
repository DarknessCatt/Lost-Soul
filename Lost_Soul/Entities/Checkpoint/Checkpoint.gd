extends Area2D

signal checkpoint_reached(checkpoint)

func _on_Checkpoint_body_entered(body : KinematicBody2D):
	body._refresh()
	$Animation.play("Activated")
	self.emit_signal("checkpoint_reached", self)
