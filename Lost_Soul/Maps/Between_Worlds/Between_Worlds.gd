extends Node2D

onready var dialogue : Label = $Hero/Player_Camera/Dialogue

const dil_intro : Array = [
"Ainda não \nestás vivo.",
"Teu corpo não\naguentaria tudo.",
"Vais ter que\ncontinuar andando.",
""
]

const dil_check : Array = [
"Posso extrair poder\ndestes altares.",
"Porém, isto dará\ntempo para",
"teus inimigos\nse recuperarem.",
""
]

const dil_soul : Array = [
"Este é um\nfragmento\nde alma,",
"deixado por\nalguma alma\nperdida.",
"Podemos usá-lo\ncomo fonte\nde poder,",
"no futuro.",
""
]

const dil_wander : Array = [
"Nem todos\nteus inimigos são\nda tua altura.",
"Lembra de\natacar baixo.",
"Se pereceres,\nte trarei de volta\nno altar.",
""
]

const dil_lost_souls : Array = [
"Almas que\ntentaram voltar,",
"mas se perderam\nna passagem do tempo,",
"deformando-se em\nsuas próprias\nloucuras.",
"De uma maneira\nou de outra,\nsão todos iguais.",
""
]

const dil_eyes : Array = [
"Estás quase\nno outro lado...",
"Já se perguntou\nporquê estas\nalmas perdidas",
"acabaram\npresas aqui?",
""
]

const dil_about_eyes : Array = [
"Sentinelas que\nestão aqui\ndesde o começo.",
"Impedindo que\nas almas voltem.",
"Porém, ainda\nnão acabou...",
""
]

enum {INTRO1, INTRO2, BEGIN}
var state : int
var first_check : bool = false

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

		$Intro_Panel.modulate.a = 0

		state = BEGIN

func _ready():
	state = INTRO1

	$Hero.health = 1

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

func _on_Intro_entered(_body):
	dialogue.change_dialogue(dil_intro)
	dialogue.begin()
	$Dialogue_Triggers/Intro.call_deferred("set","monitoring",false)

func _on_First_Check_entered(_body):
	$Tween.stop_all()
	$Tween.interpolate_property(
		$Dialogue_Triggers/First_Check/Up_Arrow, "modulate:a",
		$Dialogue_Triggers/First_Check/Up_Arrow.modulate.a, 1,
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_First_Check_exited(_body):
	$Tween.stop_all()
	$Tween.interpolate_property(
		$Dialogue_Triggers/First_Check/Up_Arrow, "modulate:a",
		$Dialogue_Triggers/First_Check/Up_Arrow.modulate.a, 0,
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_checkpoint_reached(checkpoint : Area2D):
	checkpoint.disconnect("checkpoint_reached", self, "_on_checkpoint_reached")
	$Dialogue_Triggers/First_Check.disconnect("body_entered", self, "_on_First_Check_entered")
	$Dialogue_Triggers/First_Check.disconnect("body_exited", self, "_on_First_Check_exited")

	$Tween.stop_all()
	$Tween.interpolate_property(
		$Dialogue_Triggers/First_Check/Up_Arrow, "modulate:a",
		$Dialogue_Triggers/First_Check/Up_Arrow.modulate.a, 0,
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

	first_check = true
	dialogue.change_dialogue(dil_check)
	dialogue.begin()

	var atk_event = InputEventKey.new()
	atk_event.scancode = 67
	InputMap.action_add_event("hero_attack", atk_event)

func _on_Attack_entered(_body):
	if first_check:
		$Tween.stop_all()
		$Tween.interpolate_property(
			$Dialogue_Triggers/Attack/C, "modulate:a",
			$Dialogue_Triggers/Attack/C.modulate.a, 1,
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

func _on_Attack_exited(_body):
	if first_check:
		$Tween.stop_all()
		$Tween.interpolate_property(
			$Dialogue_Triggers/Attack/C, "modulate:a",
			$Dialogue_Triggers/Attack/C.modulate.a, 0,
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

func _on_Souls_Tutorial_entered(_body):
	dialogue.change_dialogue(dil_soul)
	dialogue.begin()

func _on_Wander_Enemy_entered(_body):
	dialogue.change_dialogue(dil_wander)
	dialogue.begin()

func _on_About_Lost_entered(_body):
	dialogue.change_dialogue(dil_lost_souls)
	dialogue.begin()

func _on_Before_Eyes_entered(_body):
	dialogue.change_dialogue(dil_eyes)
	dialogue.begin()

func _on_About_Eyes_entered(_body):
	dialogue.change_dialogue(dil_about_eyes)
	dialogue.begin()

func _on_Trigger_Boss_entered(body):
	$Enemies/Boss/The_Gate_Guardian.intro(body)
	$Enemies/Boss/Trigger_Boss.call_deferred("set", "monitoring", false)
