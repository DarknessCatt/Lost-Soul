extends Node2D

const church_camera_pos : Vector2 = Vector2(-3700,-250)
const church_camera_zoom : Vector2 = Vector2(6,6)

func _input(event):
	if $Hero.on_cutscene == true and event.is_action_pressed("hero_jump"):
		$Hero.on_cutscene = false
		$Tween.seek(10)

func _ready():
	$Hero.on_cutscene = true
	$Hero._change_anim("StandingUp")
	$Tween.interpolate_property($Hero/Camera, "zoom", Vector2(0.3,0.3), Vector2(1,1), 10, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($Hero/Camera, "position", Vector2(0, 0), Vector2(0, -75), 10, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Characters/DeadManager/Manager_Text, "rect_position", Vector2(-24, 73), Vector2(-200, -151), 15, Tween.TRANS_EXPO)
	$Tween.start()

	$Characters/DeadManager/Manager_Text.begin()

func _on_Manager_Text_ended():
	$Hero.on_cutscene = false

func _on_Line_body_entered(_body):
	$Tween.stop_all()
	$Tween.interpolate_property($Hero/Camera, "zoom", Vector2(1,1), Vector2(0.6,0.6), 5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($BG, "modulate:a", 0, 0.8, 7, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()

	$Line_Dialogue.begin()

func _on_Line_body_exited(_body):
	$Tween.stop_all()
	$Tween.interpolate_property($Hero/Camera, "zoom", $Hero/Camera.zoom, Vector2(1,1), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($BG, "modulate:a", $BG.modulate.a, 0, 1, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()

	$Line_Dialogue.clear()

func _on_Jump_body_entered(_body):
	$Jump_Dialogue.begin()

func _on_Jump_Dialogue_ended():
	$Tween.stop_all()
	$Tween.interpolate_property($Jump/Z, "color:a", 0, 0.8, 3, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()

func _on_Jump_body_exited(_body):
	$Jump_Dialogue.clear()
	$Jump/Z.color.a = 0

func _on_Church_body_entered(_body):
	$MapCamera.current = true

	$Tween.stop_all()
	$Tween.interpolate_property($MapCamera, "position", $Hero/Camera.global_position, church_camera_pos, 4, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($MapCamera, "zoom", $Hero/Camera.zoom, church_camera_zoom, 4, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Church_body_exited(_body):
	$Hero/Camera.current = true
	$Hero/Camera.global_position = $MapCamera.global_position

	$Tween.stop_all()
	$Tween.interpolate_property($Hero/Camera, "position", $Hero/Camera.position, Vector2(0, -75), 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Hero/Camera, "zoom", $MapCamera.zoom, Vector2(1,1), 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Chaos_body_entered(_body):
	$Tween.stop_all()
	$Tween.interpolate_property($BG_Outro, "modulate:a", 0, 1, 2.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()
	$Outro.start()
	$Hero.on_cutscene = true
	$Hero._change_anim("Death")

func _on_Outro_timeout():
	get_tree().change_scene("res://Maps/Prototype_Mountain/Prototype_Mountain.tscn")
