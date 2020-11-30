extends Node2D

var hero : KinematicBody2D

signal room_exited()
signal soul_exited()

export(Vector2) var camera_limits : Vector2 = Vector2(1024, 600)

var boss_defeated : bool = false

func _on_Exit_entered(_body):
	self.emit_signal("room_exited")

func get_spawn_point() -> Vector2:
	return $"Entrances/0".position

#Intro
func _on_Boss_Triggered(body):
	hero = body
	body.cutscene = body.cutscene_type.PHYSICS

	$Objects/Intro/Boss_Trigger.call_deferred("set", "monitoring", false)
	$Objects/Intro/Introduction.begin_dialogue()

	$Blocks.show()
	$Blocks/Left/col.call_deferred("set", "disabled", false)
	$Blocks/Right/col.call_deferred("set", "disabled", false)

func _on_Introduction_ended():
	$Objects/The_Gate_Guardian.intro(self.hero)
	$Objects/Tween.interpolate_property($Room/Sky, "modulate:a", 1, 0.5, 6)
	$Objects/Tween.start()

func _on_Boss_intro_ended():
	hero.cutscene = hero.cutscene_type.NONE

func _on_Boss_dead():
	boss_defeated = true

	$Blocks/Left/col.call_deferred("set", "disabled", true)
	$Blocks/Right/col.call_deferred("set", "disabled", true)

	$Objects/Tween.interpolate_property($Blocks/Left, "modulate:a", 1, 0, 0.5)
	$Objects/Tween.interpolate_property($Blocks/Right, "modulate:a", 1, 0, 0.5)
	$Objects/Tween.interpolate_property($Room/Sky, "modulate:a", 0.5, 1, 1)
	$Objects/Tween.start()

func _on_Final_Soul_entered(body):
	emit_signal("soul_exited")

	$Objects/Final_Soul/Camera.current = true
	$Objects/Tween.interpolate_property($Objects/Final_Soul/Camera, "zoom",
			Vector2.ONE, Vector2(0.3,0.3), 10)
	$Objects/Tween.interpolate_property(self, "modulate:a",
			1, 10, 10)
	$Objects/Tween.start()

	$Objects/Final_Soul/Animation.play("Activated")

	body.cutscene = body.cutscene_type.PHYSICS
