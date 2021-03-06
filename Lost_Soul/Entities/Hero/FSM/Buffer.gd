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

#Attack Buffer
var attack_buffered = false

func _buffer_attack():
	attack_buffered = true
	$Attack_Buffer.start()

func _on_Attack_Buffer_timeout():
	attack_buffered = false

#Dash Buffer
var dash_buffered = false

func _buffer_dash():
	dash_buffered = true
	$Dash_Buffer.start()

func _on_Dash_Buffer_timeout():
	dash_buffered = false
