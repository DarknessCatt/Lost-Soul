extends Node2D

signal tutorial_ended()

func _process(_delta):
	$Hero.energy = $Hero.max_energy

func _on_intro_body_entered(_body):
	$Hero.cutscene = $Hero.cutscene_type.PHYSICS
	$Dialogue1/Dialogue_Trigger.call_deferred("set", "monitoring", false)
	$Animation.play("Intro")
	$Dialogue1/DialogueBox.begin_dialogue()

func _on_Intro_end():
	$Hero._change_anim("PowerUp")
	$Anim_Timer.start()
	$Animation.play_backwards("Intro")

func _on_Anim_timeout():
	$Hero.cutscene = $Hero.cutscene_type.NONE

func _on_outro_body_entered(_body):
	$Hero.cutscene = $Hero.cutscene_type.PHYSICS
	$Dialogue2/Dialogue_Trigger.call_deferred("set", "monitoring", false)
	$Dialogue2/DialogueBox.begin_dialogue()

func _on_outro_dialogue_end():
	emit_signal("tutorial_ended")
