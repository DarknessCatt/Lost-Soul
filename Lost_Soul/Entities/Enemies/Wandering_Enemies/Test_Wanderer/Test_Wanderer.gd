extends Base_Wanderer

func _hit(_damage : int, force : int, direction : Vector2):
	self.speed = direction.normalized()*force
	$Misc_Animations.play("hit")

	health -= _damage

	if health > 0:
		self._change_state($States/Knockback)

	else:
		self._change_state($States/Dead)

func respawn() -> void:
	$Body/Body.color = Color("f5f89393")
	$Body/Hitbox.call_deferred("set", "monitorable", true)
	$Hurtbox.call_deferred("set", "monitoring", true)
	.respawn()
