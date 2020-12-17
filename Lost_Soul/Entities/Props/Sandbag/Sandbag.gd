extends KinematicBody2D

#Movement
const NORMAL : Vector2 = Vector2(0, -1)

const GRAV : int = 2000
const MAX_GRAV : int = 1500

const FRICTION : float = 0.8
var speed : Vector2 = Vector2(0,0)

var invencible = false

func _hit(_damage : int, force : int, direction : Vector2):
	#print("Hit " + str(direction) + " * " + str(force))
	invencible = true
	self.speed = direction.normalized()*force
	$Animation.play("Hit")


func _on_Animation_finished(_anim_name):
	invencible = false

func _physics_process(delta):

	# warning-ignore:return_value_discarded
	move_and_slide(self.speed, NORMAL)

	if abs(self.speed.x) < 10: self.speed.x = 0

	if not self.is_on_floor():
		self.speed.y += GRAV*delta

	else:
		self.speed.x *= FRICTION
		self.speed.y = 20

	if self.is_on_wall():
		self.speed.x *= -0.8
