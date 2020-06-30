extends "State.gd"

const NORMAL : Vector2 = Vector2(0, -1)

const GRAV : int = 3500
const MAX_GRAV : int = 1500
const FRICTION : float = 0.8

var knockback_over : bool = false

func enter(_Player : KinematicBody2D) -> void:
	_Player.invencible = true
	_Player._change_anim("OnHit")
	knockback_over = false
	$Inv_Timer.start()

func update(_Player: KinematicBody2D, delta : float) -> void:
	if knockback_over:
		if _Player.is_on_floor():
			_Player._change_state($"../OnGround")

		else:
			_Player._change_state($"../Falling")

	else:
		var spd : Vector2 = _Player.speed

		spd.x *= FRICTION

		spd.y += GRAV*delta
		if spd.y > MAX_GRAV: spd.y = MAX_GRAV

		_Player.speed = spd

		_Player.move_and_slide(_Player.speed, NORMAL)

func _anim_done():
	knockback_over = true
