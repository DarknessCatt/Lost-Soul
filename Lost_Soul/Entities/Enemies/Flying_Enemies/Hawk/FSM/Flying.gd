extends State

const Point_To_Seek : Vector2 = Vector2(0,0)

#Movement info
const NORMAL : Vector2 = Vector2(0, -1)
const ACCEL : int = 500
const ROT_ACCEL : int = 10
const MAX_SPEED : int = 1200
const FRICTION : float = 0.9

#Functions
func enter(Hawk : KinematicBody2D) -> void:
	Hawk.change_animation("Diving")
	var dirx : float = Hawk.hero.global_position.x + Point_To_Seek.x - Hawk.global_position.x
	Hawk.body.scale.x = sign(dirx)

func exit(Hawk : KinematicBody2D) -> void:
	$Atk_CD.start()
	Hawk.can_attack = false
	Hawk.body.rotation = 0

func update(Hawk: KinematicBody2D, delta : float) -> void:
	var dir : Vector2 = ((Hawk.hero.global_position + Point_To_Seek) - Hawk.global_position).normalized()
	var spd : Vector2 = Hawk.speed + dir*ACCEL*delta

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

	if Hawk.body.scale.x != sign(dir.x):
		Hawk.body.scale.x = sign(dir.x)

	if dir.x >= 0:
		Hawk.body.rotation = dir.angle()
	else:
		Hawk.body.rotation = dir.angle()+3.14

	Hawk.speed = spd

	# warning-ignore:return_value_discarded
	Hawk.move_and_slide(Hawk.speed, NORMAL)

	if Hawk.is_on_floor() or Hawk.is_on_ceiling():
		Hawk.speed.y *= -1

	if Hawk.is_on_wall():
		Hawk.speed.x *= -1
