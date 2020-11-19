extends Node2D

var hero : KinematicBody2D

signal room_exited()

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
