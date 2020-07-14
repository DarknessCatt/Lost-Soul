extends "AttackMove.gd"

func enter(_Player : KinematicBody2D) -> void:
	.enter(_Player)

	var attack : String
	var timer : Timer

	if Input.is_action_pressed("hero_down"):
		attack = "Air_Jab_Down"
		#timer = $DownTilt

	elif Input.is_action_pressed("hero_up"):
		attack = "Air_Jab_Up"
		#timer = $UpTilt

	else:
		attack = "Air_Jab"
		#timer = $Jab

	_Player._change_anim(attack)
	timer.start()

func update(_Player: KinematicBody2D, _delta : float) -> void:
	if attack_finished:
		if _Player.is_on_floor():
			if buffer.attack_buffered:
				_Player._change_state($"../GroundAttack")

			else:
				_Player._change_state($"../OnGround")

		else:
			if buffer.attack_buffered:
				_Player._change_state($"../AirAttack")

			else:
				_Player._change_state($"../Falling")

	else:
		.update(_Player, _delta)

		if _Player.is_on_floor():
			if buffer.attack_buffered:
				_Player._change_state($"../GroundAttack")

			else:
				_Player._change_state($"../OnGround")
