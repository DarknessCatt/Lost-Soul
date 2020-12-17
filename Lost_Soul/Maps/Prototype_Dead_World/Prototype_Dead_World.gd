extends Node2D

const line_dialogue : Array = [
"...", "A dor dentro\nde ti...",
"Ir para o além\nnão a curará.",
"Se me ouves,\nme procure.",
"Eu posso te\najudar...",
"Estou longe\ndai."]

const left_dialogue : Array = [
"Eu posso te\najudar a voltar.", ""
]

const soul_dialogue : Array = [
"Fragmentos\nde alma...?      ", ""
]

const middle_dialogue : Array = [
"O que te mantém\npreso a este corpo?",
"Talvez...      \nVingança?      ", ""
]

const end_dialogue : Array = [
"Estás perto agora.",
"Como ti, estou\npreso aqui,",
"mas posso\nte levar de volta.     ",
""
]
const soul2_dialogue : Array = [
"Boa descoberta.",
"Tu deverias falar\nisto para algum\ncriador!          ",
""
]
const church_camera_pos : Vector2 = Vector2(-4700,-30)
const church_camera_zoom : Vector2 = Vector2(6,6)

onready var dialogue : Label = $Hero/Camera/Dialogue

func _input(event):
	if $Hero.cutscene != $Hero.cutscene_type.NONE and event.is_action_pressed("hero_jump"):
		$Hero.cutscene = $Hero.cutscene_type.NONE
		$Tween.seek(10)

func _ready():
	InputMap.action_erase_events("hero_attack")
	InputMap.action_erase_events("hero_block")

	$Hero.cutscene = $Hero.cutscene_type.FULL
	$Hero._change_anim("StandingUp")
	$Tween.interpolate_property($Hero/Camera, "zoom", Vector2(0.3,0.3), Vector2(1,1), 10, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($Hero/Camera, "position", Vector2(0, 0), Vector2(0, -75), 10, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Characters/DeadManager/Manager_Text, "rect_position", Vector2(-24, 73), Vector2(-200, -151), 15, Tween.TRANS_EXPO)
	$Tween.start()

	$Characters/DeadManager/Manager_Text.begin()

func _on_Manager_Text_ended():
	$Hero.cutscene = $Hero.cutscene_type.NONE

func _on_Line_body_entered(_body):
	$Tween.stop_all()
	$Tween.interpolate_property($Hero/Camera, "zoom", Vector2(1,1), Vector2(0.6,0.6), 5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($BG, "modulate:a", 0, 0.8, 7, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()

	dialogue.change_dialogue(line_dialogue)
	dialogue.begin()

func _on_Line_body_exited(_body):
	$Tween.stop_all()
	$Tween.interpolate_property($Hero/Camera, "zoom", $Hero/Camera.zoom, Vector2(1,1), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($BG, "modulate:a", $BG.modulate.a, 0, 1, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()

	dialogue.clear()

func _on_Left_body_entered(body):
	dialogue.change_dialogue(left_dialogue)
	dialogue.begin()
	$Left.call_deferred("set","monitoring",false)

func _on_Jump_body_entered(_body):
	$Tween.stop_all()
	$Tween.interpolate_property($Jump/Tutorial_Button, "modulate:a", 0, 1, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()

func _on_Jump_body_exited(_body):
	dialogue.clear()
	$Jump/Tutorial_Button.modulate.a = 0

func _on_Souls_1_body_entered(body):
	dialogue.change_dialogue(soul_dialogue)
	dialogue.begin()

func _on_Middle_body_entered(body):
	dialogue.change_dialogue(middle_dialogue)
	dialogue.begin()
	$Middle.call_deferred("set","monitoring",false)

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

func _on_End_body_entered(body):
	dialogue.change_dialogue(end_dialogue)
	dialogue.begin()
	$End.call_deferred("set","monitoring",false)

func _on_Souls_2_body_entered(body):
	dialogue.change_dialogue(soul2_dialogue)
	dialogue.begin()

func _on_Chaos_body_entered(_body):
	$Tween.stop_all()
	$Tween.interpolate_property($BG_Outro, "modulate:a", 0, 1, 2.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()
	$Outro.start()
	$Hero.cutscene = $Hero.cutscene_type.FULL
	$Hero._change_anim("Death")

func _on_Outro_timeout():
	get_tree().change_scene("res://Maps/Between_Worlds/Between_Worlds.tscn")

