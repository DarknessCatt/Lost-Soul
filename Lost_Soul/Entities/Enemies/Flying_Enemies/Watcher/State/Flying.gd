extends State

#State info
export(String) var state_anim : String = "Flying"
const BULLET_RES : Resource = preload("res://Entities/Enemies/Flying_Enemies/Watcher/Components/Watcher_Shoot.tscn")

#Movement info
const STOP_DIST : int = 10

const NORMAL : Vector2 = Vector2(0, -1)
export(int) var ACCEL : int = 500
export(int) var MAX_SPEED : int = 200
export(float) var FRICTION : float = 0.9
export(Vector2) var Point_To_Seek : Vector2 = Vector2(0,0)

#Attack FSM
var atk : bool = false

#Functions
func enter(_Player : KinematicBody2D) -> void:
	_Player.change_animation(state_anim)

func update(_Player: KinematicBody2D, _delta : float) -> void:
	var dir : Vector2 = ((_Player.hero.global_position + Point_To_Seek) - _Player.global_position)
	var spd : Vector2 = _Player.speed + dir.normalized()*ACCEL*_delta

	if dir.length() <= STOP_DIST : spd *= FRICTION
	dir = dir.normalized()

	if sign(spd.x) != sign(dir.x) : spd.x *= FRICTION
	if sign(spd.y) != sign(dir.y) : spd.y *= FRICTION

	if spd.length() > MAX_SPEED:
		# warning-ignore:integer_division
		if spd.length() - MAX_SPEED < ACCEL/10 : spd = MAX_SPEED*spd.normalized()
		else : spd *= FRICTION
	else:
		# warning-ignore:integer_division
		if abs(spd.x) < ACCEL/100: spd.x = 0
		# warning-ignore:integer_division
		if abs(spd.y) < ACCEL/100: spd.y = 0

	_Player.speed = spd

	_Player.move_and_slide(_Player.speed, NORMAL)

	if _Player.is_on_floor() or _Player.is_on_ceiling():
		_Player.speed.y *= -1

	if _Player.is_on_wall():
		_Player.speed.x *= -1

	if atk:
		var bullet = BULLET_RES.instance()
		bullet.position = _Player.position + _Player.body.get_node("Eye/Iris").position.rotated(_Player.body.rotation)
		bullet.rotation = _Player.body.rotation
		_Player.get_parent().add_child(bullet)

		atk = false

func shoot():
	atk = true
