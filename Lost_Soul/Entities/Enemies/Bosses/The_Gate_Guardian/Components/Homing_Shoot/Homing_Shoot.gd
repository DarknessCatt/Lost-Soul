extends KinematicBody2D

var MAX_SPEED : int = 500
var SPEED : int = 450
var ACCEL : int = 10
var dir : Vector2 = Vector2(1,0)
var collided : bool = false

var hero : KinematicBody2D

func _ready():
	assert(hero != null, "Homing Shot: Hero is null!")
	dir = dir.rotated(self.rotation)
	dir *= SPEED

func _physics_process(delta):
	if not collided:
		dir = dir + (hero.global_position - self.global_position)*ACCEL*delta
		dir = dir.clamped(MAX_SPEED)
		var col = self.move_and_collide(dir*delta)
		if col != null:
			_die()

func _on_Self_Destruct_timeout():
	if collided:
		self.call_deferred("free")

	else:
		_die()

func _die():
	collided = true
	$Splash.emitting = true
	$SFX.stop()
	$Body.hide()
	self.call_deferred("set_collision_mask_bit", 0, false)
	$Hitbox.call_deferred("set", "monitorable", false)
	$Self_Destruct.start(1)

func respawn():
	self.call_deferred("free")
