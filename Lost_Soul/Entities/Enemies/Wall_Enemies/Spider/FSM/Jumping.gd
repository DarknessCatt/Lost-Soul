extends State

const GRAV : int = 1000

const MIN_DIST : int = 32
const MAX_DIST : int = 600

const MIN_JUMP : int = -800
const MAX_JUMP : int = -500

func enter(Spider : KinematicBody2D) -> void:
	var target = Spider.Player.global_position

	var jump_strengh : Vector2 = Vector2.ZERO
	var dist = target.x - Spider.global_position.x

	dist = sign(dist)*max(min(MAX_DIST, abs(dist)), MIN_DIST)

	jump_strengh.x = dist

	dist = abs(dist)
	jump_strengh.y = (MAX_DIST-dist)*MIN_JUMP + MAX_JUMP*(dist - MIN_DIST)
	jump_strengh.y /= (MAX_DIST-MIN_DIST)

	if Spider.cur_surface == Spider.surface_positions.Wall:
		jump_strengh.y *= 0.5
		jump_strengh.x *= 2
		jump_strengh.x = abs(jump_strengh.x)*sign(Vector2(0,-1).rotated(Spider.body.rotation).x)

	elif Spider.cur_surface == Spider.surface_positions.Ceiling:
		jump_strengh.y *= -1
		jump_strengh.x *= 1.5

	Spider.speed = jump_strengh

#func exit(_Spider : KinematicBody2D) -> void:
#	pass

func update(Spider: KinematicBody2D, delta : float) -> void:
	Spider.speed.y += GRAV*delta
	Spider.body.rotation = Spider.speed.angle() + 1.57
	# warning-ignore:return_value_discarded
	Spider.move_and_slide(Spider.speed, Vector2.UP, true, 2)

	var player_collided : bool = false

	for i in Spider.get_slide_count():
		var collision = Spider.get_slide_collision(i)
		if collision.collider.get_collision_layer_bit(0) == true:
			player_collided = true
			var knockback : Vector2 = Spider.Player.global_position - Spider.global_position
			Spider.speed = MAX_JUMP*knockback.normalized()
			break

	if not player_collided:

		if Spider.is_on_floor():
			Spider.cur_surface = Spider.surface_positions.Ground
			Spider._change_state($"../Attacking")

		elif Spider.is_on_wall():
			Spider.cur_surface = Spider.surface_positions.Wall
			Spider._change_state($"../Attacking")

		elif Spider.is_on_ceiling():
			Spider.cur_surface = Spider.surface_positions.Ceiling
			Spider._change_state($"../Attacking")
