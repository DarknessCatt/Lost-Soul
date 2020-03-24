extends Node

#Buffers Players Inputs

#Landing Jump buffer
var jump_buffered : bool = false

func _buffer_jump():
	jump_buffered = true
	$Jump_Buffer.start()

func _on_Jump_Buffer_timeout():
	jump_buffered = false

#Coyote Jump
var can_coyote : bool = false

func _coyote_timer():
	can_coyote = true
	$Coyote_Timer.start()

func _on_Coyote_Timer_timeout():
	can_coyote = false

#Ground Combo Counter
var attack_num : int = 0

func _register_attack(num : int):
	attack_num = num
	$Combo_Timer.stop()

func _attack_end():
	$Combo_Timer.start()

func _on_Combo_Timer_timeout():
	attack_num = 0

#Ground Combo Counter
var air_attack_num : int = 0

func _register_air_attack(num : int):
	air_attack_num = num
	$Combo_Timer.stop()

func _air_attack_end():
	$Combo_Timer.start()
