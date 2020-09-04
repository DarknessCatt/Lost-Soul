extends Area2D

export(int) var exit_id : int = 0

signal exit_entered(body, id)

func _on_body_entered(body):
	self.emit_signal("exit_entered", body, exit_id)
