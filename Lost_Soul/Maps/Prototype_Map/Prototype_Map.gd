extends Node2D

const church_camera_pos : Vector2 = Vector2(-4690,-250)
const church_camera_zoom : Vector2 = Vector2(6,6)

enum {NONE, LINE, JUMP, CHURCH}
var STATE = NONE

var line_lines : Array = ["Então, é isso?\n                    ",
						 "Vai desistir\nfacil assim?\n                    ",
						 "Acredito que você\nainda tenha\nassuntos pendentes.\n                    ",
						 "Eu posso te\najudar a voltar.\n                    ",
						 "Saia desta fila,\nme encontre.\n                   "]
var jump_lines : Array = ["Eu aprecio a\ntua determinação.\n                    ",
						 "Mas você ainda não\nestá acostumado\ncom este corpo.\n                    ",
						 "Foque na tua mente\npara pular."]

var current_lines : Array
var line_num : int = 0

func _on_Textbox_ended():
	if line_num < len(current_lines):
		$Hero/Textbox.change_text(current_lines[line_num])
		line_num += 1
	else:
		if STATE == JUMP:
			$Tween.stop_all()
			$Tween.interpolate_property($Jump/Z, "color:a", 0, 0.8, 4, Tween.TRANS_SINE, Tween.EASE_IN)
			$Tween.start()

func _on_Line_body_entered(_body):
	STATE = LINE

	current_lines = line_lines
	$Hero/Textbox.change_text(current_lines[line_num])
	line_num += 1

	$Tween.stop_all()
	$Tween.interpolate_property($Hero/Camera, "zoom", Vector2(1,1), Vector2(0.6,0.6), 5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($BG, "modulate:a", 0, 0.8, 7, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()

func _on_Line_body_exited(_body):
	STATE = NONE

	$Hero/Textbox.clear()
	line_num = 0

	$Tween.stop_all()
	$Tween.interpolate_property($Hero/Camera, "zoom", $Hero/Camera.zoom, Vector2(1,1), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($BG, "modulate:a", $BG.modulate.a, 0, 1, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()

func _on_Jump_body_entered(_body):
	STATE = JUMP
	current_lines = jump_lines
	$Hero/Textbox.change_text(current_lines[line_num])
	line_num += 1

func _on_Jump_body_exited(_body):
	STATE = NONE
	$Hero/Textbox.clear()
	line_num = 0

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

func _on_Tween_tween_all_completed():
	if STATE == LINE:
		$Hero/Textbox.begin()
