extends KinematicBody2D

#Movement
const NORMAL : Vector2 = Vector2(0, -1)

const GRAV : int = 3000
const MAX_GRAV : int = 1500

const FRICTION : float = 0.7
var speed : Vector2 = Vector2(0,0)

func _hit(_damage : int, force : int, direction : Vector2):
	#print("Hit " + str(direction) + " * " + str(force))
	self.speed = direction.normalized()*force

func _physics_process(delta):

	move_and_slide(self.speed, NORMAL)

	if abs(self.speed.x) < 10: self.speed.x = 0

	if not self.is_on_floor():
		self.speed.y += GRAV*delta

	else:
		self.speed.x *= FRICTION
		self.speed.y = 20
