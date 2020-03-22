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
