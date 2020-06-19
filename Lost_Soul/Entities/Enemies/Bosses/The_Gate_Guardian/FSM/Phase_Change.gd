extends State

var scene_done : bool = false
var shaking_eye : bool = false

var eye : Polygon2D
var iris : Polygon2D

const shake_dist : float = 5.0

#Movement Speed
const NORMAL : Vector2 = Vector2(0, -1)
var speed : Vector2 = Vector2(0,0)
const ACCEL : int = 500
const MAX_SPEED : int = 300
const FRICTION : float = 0.95

func enter(Guardian : KinematicBody2D) -> void:
	Guardian.animation.travel("Idle_2")

	eye = Guardian.body.get_node("Eye")
	iris = Guardian.body.get_node("Eye/Iris")

	speed = (-Guardian.position).normalized()*MAX_SPEED*5

	Guardian.get_node("Hitbox").call_deferred("set", "monitorable", false)
	Guardian.get_node("Hurtbox").call_deferred("set", "monitoring", false)

func exit(Guardian : KinematicBody2D) -> void:
	Guardian.get_node("Hurtbox").call_deferred("set", "monitoring", true)
	Guardian.get_node("Hitbox").call_deferred("set", "monitorable", true)

func update(Guardian: KinematicBody2D, delta : float) -> void:
	#Handling Movement
	var move_dir : Vector2 = (-Guardian.position)

	speed += move_dir.normalized()*ACCEL*delta

	if sign(speed.x) != sign(move_dir.x) : speed.x *= FRICTION
	if sign(speed.y) != sign(move_dir.y) : speed.y *= FRICTION

	if speed.length() > MAX_SPEED:
		if speed.length() - MAX_SPEED < ACCEL/10: speed = MAX_SPEED*speed.normalized()
		else: speed *= FRICTION

	else:
		if abs(speed.x) < 1: speed.x = 0
		if abs(speed.y) < 1: speed.y = 0

	Guardian.move_and_slide(speed, NORMAL)

	if scene_done:
		#Guardian.emit_signal("phase_changed")
		Guardian._change_state($"../Phase2")

	elif shaking_eye:
		eye.position.x = rand_range(-shake_dist, shake_dist)
		eye.position.y = rand_range(-shake_dist, shake_dist)
		iris.position.x = rand_range(-shake_dist, shake_dist)
		iris.position.x = rand_range(-shake_dist, shake_dist)

#Functions called by "Phase_2" animation

func shake_eye() -> void:
	shaking_eye = true

func scene_ended() -> void:
	scene_done = true
	eye.position = Vector2(0,0)
	iris.position = Vector2(0,0)

