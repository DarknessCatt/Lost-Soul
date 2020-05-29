extends Node2D

enum {INTRO1, INTRO2, BEGIN}
var state : int

func _on_Tween_tween_all_completed():
	match(state):
		INTRO1:
			$Hero._change_anim("PowerUp")
			$Tween.interpolate_property(
				$Intro_Panel, "modulate:a",
				$Intro_Panel.modulate.a, 0,
				2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			$Tween.interpolate_property(
				$Intro_Camera, "zoom",
				$Intro_Camera.zoom, $Hero/Player_Camera.zoom,
				2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			$Tween.start()
			state = INTRO2

		INTRO2:
			state = BEGIN
			$Hero/Player_Camera.current = true
			$Hero/Player_Camera.show()
			var atk_event = InputEventKey.new()
			atk_event.scancode = 67
			InputMap.action_add_event("hero_attack", atk_event)

func _input(event):
	if event.is_action_pressed("hero_jump") and (state == INTRO1 or state == INTRO2):
		$Tween.stop_all()

		$Hero.on_cutscene = false
		$Hero/Player_Camera.current = true
		$Hero/Player_Camera.show()

		var atk_event = InputEventKey.new()
		atk_event.scancode = 67
		InputMap.action_add_event("hero_attack", atk_event)

		$Intro_Panel.modulate.a = 0

		state = BEGIN

func _ready():
	state = INTRO1
	$Tween.interpolate_property(
		$Intro_Camera, "global_position",
		$Intro_Camera.global_position, $Hero/Player_Camera.global_position,
		5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(
		$Intro_Camera, "zoom",
		$Intro_Camera.zoom, Vector2(2, 0.5),
		5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(
		$Intro_Panel, "modulate:a",
		1, 0.5,
		5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$Hero.on_cutscene = true

