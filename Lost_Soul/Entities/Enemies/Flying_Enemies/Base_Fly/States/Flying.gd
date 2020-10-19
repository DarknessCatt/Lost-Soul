extends State

#State info
export(String) var state_anim : String = "Flying"

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
export(int) var ACCEL : int = 500
export(int) var MAX_SPEED : int = 200
export(float) var FRICTION : float = 0.9
export(Vector2) var Point_To_Seek : Vector2 = Vector2(0,0)

#Functions
func enter(Flyer : KinematicBody2D) -> void:
	Flyer.change_animation(state_anim)
	var dirx : float = Flyer.hero.global_position.x + Point_To_Seek.x - Flyer.global_position.x
	match sign(dirx):
			-1.0:
				Flyer.body.scale.x = -1
			1.0:
				Flyer.body.scale.x = 1

func update(Flyer: KinematicBody2D, _delta : float) -> void:
	var dir : Vector2 = ((Flyer.hero.global_position + Point_To_Seek) - Flyer.global_position).normalized()
	var spd : Vector2 = Flyer.speed + dir*ACCEL*_delta

	if sign(spd.x) != sign(dir.x) : spd.x *= FRICTION
	if sign(spd.y) != sign(dir.y) : spd.y *= FRICTION

	if spd.length() > MAX_SPEED*1.4:
		# warning-ignore:integer_division
		if spd.length() - MAX_SPEED < ACCEL/10 : spd = MAX_SPEED*spd.normalized()
		else : spd *= FRICTION
	else:
		# warning-ignore:integer_division
		if abs(spd.x) < ACCEL/100: spd.x = 0
		# warning-ignore:integer_division
		if abs(spd.y) < ACCEL/100: spd.y = 0

	if sign(spd.x) != sign(dir.x):
		match sign(dir.x):
			-1.0:
				Flyer.body.scale.x = -1
			1.0:
				Flyer.body.scale.x = 1

	Flyer.speed = spd

	# warning-ignore:return_value_discarded
	Flyer.move_and_slide(Flyer.speed, NORMAL)

	if Flyer.is_on_floor() or Flyer.is_on_ceiling():
		Flyer.speed.y *= -1

	if Flyer.is_on_wall():
		Flyer.speed.x *= -1
