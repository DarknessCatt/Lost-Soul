extends Node2D

func _process(_delta):
	$Hero.energy = $Hero.max_energy

func _on_intro_body_entered(_body):
	$Hero.on_cutscene = true
	$Dialogue1/Dialogue_Trigger.call_deferred("set", "monitoring", false)
	$Animation.play("Intro")
	$Dialogue1/DialogueBox.begin_dialogue()

func _on_Intro_end():
	$Hero._change_anim("PowerUp")
	$Anim_Timer.start()
	$Animation.play_backwards("Intro")

func _on_Anim_timeout():
	$Hero.on_cutscene = false
