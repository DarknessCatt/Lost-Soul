extends KinematicBody2D

var SPEED : int = 200
var dir : Vector2 = Vector2(1,0)
var collided : bool = false

func _ready():
	dir = dir.rotated(self.rotation)
	dir *= SPEED

func _physics_process(delta):
	if not collided:
		var col = self.move_and_collide(dir*delta)
		if col != null:
			collided = true
			$Splash.emitting = true
			$Shot.hide()
			$Hitbox.call_deferred("set", "monitorable", false)
			$Self_Destruct.start(1)

func _on_Self_Destruct_timeout():
	self.call_deferred("free")

func respawn():
	self.call_deferred("free")
