extends State

var knockback_finished : bool = false

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
export(float) var FRICTION : float = 0.8
export(int) var GRAVITY : int = 3500
export(int) var MAX_GRAV : int = 2000

#Functions
func enter(_Player : KinematicBody2D) -> void:
	_Player.change_animation("Knockback")
	knockback_finished = false

func update(_Player: KinematicBody2D, _delta : float) -> void:
	if knockback_finished:
		if _Player.is_on_floor():
			_Player._change_state($"../Walking")
		else:
			_Player._change_state($"../Falling")

	else:
		_Player.speed.x *= FRICTION

		_Player.speed.y += GRAVITY*_delta
		if _Player.speed.y > MAX_GRAV: _Player.speed.y = MAX_GRAV

		_Player.move_and_slide(_Player.speed, NORMAL)

		if _Player.is_on_ceiling():
			_Player.speed.y = 0

func _on_animation_finished(_anim_name):
	knockback_finished = true
