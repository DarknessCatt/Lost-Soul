extends KinematicBody2D

const SPEED : int = 300
var dir : Vector2 = Vector2(1,0)

func _ready():
	dir = dir.rotated(self.rotation)
	dir *= SPEED

func _physics_process(delta):
	var col = self.move_and_collide(dir*delta)
	if col != null:
		self.call_deferred("free")

func _on_Self_Destruct_timeout():
	self.call_deferred("free")
