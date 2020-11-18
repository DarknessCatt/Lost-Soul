extends Node2D

signal room_exited()

export(Vector2) var camera_limits : Vector2 = Vector2(1024, 600)

var boss_defeated : bool = false

func _on_Exit_entered(_body):
	self.emit_signal("room_exited")

func get_spawn_point() -> Vector2:
	return $"Entrances/0".position
