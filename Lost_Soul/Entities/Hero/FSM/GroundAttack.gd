extends "AttackMove.gd"

var left_attack : bool = false

func enter(_Player : KinematicBody2D) -> void:
	.enter(_Player)

	var attack : String
	var timer : Timer

	if Input.is_action_pressed("hero_down"):
		attack = "Jab_Down"
		timer = $DownTilt

	elif Input.is_action_pressed("hero_up"):
		attack = "Jab_Up"
		timer = $UpTilt

	else:
		attack = "Jab_Right"
		timer = $Jab

		if left_attack: attack = "Jab_Left"
		left_attack = not left_attack

	_Player._change_anim(attack)
	timer.start()

func update(_Player: KinematicBody2D, delta : float) -> void:
	if attack_finished:
		if _Player.is_on_floor():
			if buffer.jump_buffered:
				_Player._change_state($"../Jumping")

			elif buffer.attack_buffered and buffer.can_attack:
				_Player._change_state($"../GroundAttack")

			else:
				_Player._change_state($"../OnGround")

		else:
			if buffer.attack_buffered and buffer.can_attack:
				_Player._change_state($"../AirAttack")

			else:
				_Player._change_state($"../Falling")

	else:
		.update(_Player, delta)
