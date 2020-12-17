extends State

var fall_speed : float = 0.0

#"FSM"
var outro : bool = false

func enter(Guardian : KinematicBody2D) -> void:
	Guardian.animation.travel("Dead")
	Guardian.set_collision_layer_bit(1, 0)

func update(Guardian: KinematicBody2D, delta : float) -> void:
	if not outro:
		var move : Vector2 = Vector2(0,-10)
		move.x = rand_range(-50,50)
		# warning-ignore:return_value_discarded
		Guardian.move_and_slide(move)

	else:
		fall_speed = 40000*delta
		fall_speed = min(10000, fall_speed)
		# warning-ignore:return_value_discarded
		Guardian.move_and_slide(Vector2(0,fall_speed))

func hit(_damage : int, _force : int, _direction : Vector2) -> void:
	pass

#Called by "Dead" anim
func begin_outro() -> void:
	outro = true
