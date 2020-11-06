extends Area2D

export(PackedScene) var tutorial_scene : PackedScene
signal power_activated(scene)

var on_zone : bool = false
var consumed : bool = false

func _on_PowerUp_entered(_body):
	if not consumed:
		$Animation.play("Close")
		on_zone = true

func _on_PowerUp_exited(_body):
	if not consumed:
		$Animation.play("rest")
		on_zone = false

func _input(event):
	if not consumed and on_zone and event.is_action_pressed("hero_up"):
		emit_signal("power_activated", tutorial_scene)
		consumed = true
		$Animation.play("Consumed")
