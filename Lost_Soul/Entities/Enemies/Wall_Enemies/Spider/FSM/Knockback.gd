extends State

export(bool) var over : bool = false #set by hit animation

const GRAV : int = 1000

func enter(Spider : KinematicBody2D) -> void:
	Spider.change_animation("hit")
	Spider.change_boxes(false)
	over = false

func exit(Spider : KinematicBody2D) -> void:
	Spider.change_boxes(true)

func update(Spider: KinematicBody2D, delta : float) -> void:
	Spider.speed.y += GRAV*delta
	Spider.body.rotation = Spider.speed.angle() + 1.57
	# warning-ignore:return_value_discarded
	Spider.move_and_slide(Spider.speed, Vector2.UP, true, 2)

	if over:
		var player_collided : bool = false

		for i in Spider.get_slide_count():
			var collision = Spider.get_slide_collision(i)
			if collision.collider.get_collision_layer_bit(0) == true:
				player_collided = true
				var knockback : Vector2 = collision.collider.global_position - Spider.global_position
				Spider.speed = -500*knockback.normalized()
				break

		if not player_collided:

			if Spider.Player == null and Spider.get_slide_count() > 0:
				Spider._change_state($"../Idle")

			elif Spider.is_on_floor():
				Spider.cur_surface = Spider.surface_positions.Ground
				Spider._change_state($"../Attacking")

			elif Spider.is_on_wall():
				Spider.cur_surface = Spider.surface_positions.Wall
				Spider._change_state($"../Attacking")

			elif Spider.is_on_ceiling():
				Spider.cur_surface = Spider.surface_positions.Ceiling
				Spider._change_state($"../Attacking")

	else:

		if Spider.is_on_wall():
			Spider.speed.x *= -0.8

		elif Spider.is_on_ceiling():
			Spider.speed.y = 0
