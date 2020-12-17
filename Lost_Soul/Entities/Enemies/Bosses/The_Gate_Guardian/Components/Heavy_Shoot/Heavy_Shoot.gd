extends KinematicBody2D

export(PackedScene) var smaller_shot : PackedScene

const inicial_rad = -1.57
const increment = 0.449

var SPEED : int = 250
var dir : Vector2 = Vector2(1,0)
var collided : bool = false

func _ready():
	dir = dir.rotated(self.rotation)
	dir *= SPEED

func _physics_process(delta):
	if not collided:
		var col : KinematicCollision2D = self.move_and_collide(dir*delta)
		if col != null:

			for i in 10:
				var bullet = smaller_shot.instance()
				bullet.SPEED = 700
				bullet.position = self.position + col.normal*10
				bullet.rotation = inicial_rad + i*increment + col.normal.angle()
				self.get_parent().add_child(bullet)

			collided = true
			$Splash.emitting = true
			$Shot.hide()
			$Hitbox.call_deferred("set", "monitorable", false)
			$Self_Destruct.start(1.5)

func _on_Self_Destruct_timeout():
	self.call_deferred("free")

func respawn():
	self.call_deferred("free")
