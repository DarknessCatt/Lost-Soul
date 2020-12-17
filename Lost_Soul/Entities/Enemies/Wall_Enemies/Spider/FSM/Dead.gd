extends State

const GRAV : int = 1000

func enter(Spider : KinematicBody2D) -> void:
	Spider.set_collision_layer_bit(1, 0)
	Spider.change_animation("dead")
	Spider.change_boxes(false)

func exit(Spider : KinematicBody2D) -> void:
	Spider.change_boxes(true)
	Spider.set_collision_layer_bit(1, 1)

func update(Spider: KinematicBody2D, delta : float) -> void:
	Spider.speed.y += GRAV*delta
	Spider.speed.y = min(5000, Spider.speed.y)
	Spider.body.rotation = Spider.speed.angle() + 1.57
	# warning-ignore:return_value_discarded
	Spider.move_and_slide(Spider.speed, Vector2.UP, true, 2)

	if Spider.is_on_floor():
		Spider.speed.x *= 0.9

	elif Spider.is_on_wall():
		Spider.speed.x *= -0.8

	elif Spider.is_on_ceiling():
		Spider.speed.y = 0
