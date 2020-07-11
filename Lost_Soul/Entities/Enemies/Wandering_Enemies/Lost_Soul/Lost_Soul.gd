extends Base_Wanderer

func _hit(_damage : int, force : int, direction : Vector2):

	if direction.y != 0:
		self.speed = force*direction.normalized()
	else:
		self.speed.x = force*direction.normalized().x

	$Misc_Animations.play("hit")

	health -= _damage

	if health <= 0:
		self._change_state($States/Dead)
		self.spawn_souls()

func respawn() -> void:
	$Body/Torso/Head.rotation = 0
	$Body/Torso/Left_Arm.rotation = 0
	$Body/Torso/Right_Arm.rotation = 0
	$Body/Right_Leg.rotation = 0
	$Body/Left_Leg.rotation = 0
	self.modulate = Color("ffffff")
	$Body/Hitbox.call_deferred("set", "monitorable", true)
	$Hurtbox.call_deferred("set", "monitoring", true)
	$Collision.scale = Vector2(1,1)
	$Collision.position = Vector2(0,1)
	.respawn()
