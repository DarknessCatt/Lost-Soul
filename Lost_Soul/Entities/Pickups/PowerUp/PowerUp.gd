extends Area2D

export(String) var power : String
export(PackedScene) var tutorial_scene : PackedScene
signal power_activated(scene)

var hero : KinematicBody2D
var on_zone : bool = false
var consumed : bool = false

func _on_PowerUp_entered(body):
	if not consumed:
		hero = body
		$Animation.play("Close")
		on_zone = true

func _on_PowerUp_exited(_body):
	if not consumed:
		$Animation.play("rest")
		on_zone = false

func _input(event):
	if not consumed and on_zone and event.is_action_pressed("hero_interact"):
		assert(hero.available_powers.has(power), "PowerUp has no Power Assigned!")
		$Tutorial_Action.disabled = true
		emit_signal("power_activated", tutorial_scene)
		hero.available_powers[power] = true
		consumed = true
		$Animation.play("Consumed")
