extends State

var intro_done : bool = false
var shaking_eye : bool = false

var eye : Polygon2D
var iris : Polygon2D

const shake_dist : float = 5.0

func enter(Guardian : KinematicBody2D) -> void:
	Guardian.animation.start("rest")
	eye = Guardian.body.get_node("Eye")
	iris = Guardian.body.get_node("Eye/Iris")

func update(Guardian: KinematicBody2D, _delta : float) -> void:
	if intro_done:
		Guardian._change_state($"../Phase1")

	elif shaking_eye:
		eye.position.x = rand_range(-shake_dist, shake_dist)
		eye.position.y = rand_range(-shake_dist, shake_dist)
		iris.position.x = rand_range(-shake_dist, shake_dist)
		iris.position.x = rand_range(-shake_dist, shake_dist)

#Functions called by "Spawning" animation

func shake_eye() -> void:
	shaking_eye = true

func intro_ended() -> void:
	intro_done = true
	eye.position = Vector2(0,0)
	iris.position = Vector2(0,0)

