extends Base_Wanderer

func _hit(damage : int, force : int, direction : Vector2):
	self.speed = direction.normalized()*force
	$Misc_Animations.play("hit")

	health -= damage

	if health > 0:
		self._change_state($States/Knockback)

	else:
		self._change_state($States/Dead)
		self.spawn_souls()

func respawn() -> void:
	self.set_collision_layer_bit(1, 1)
	$Body/Body.color = Color("f5f89393")
	$Body/Hitbox.call_deferred("set", "monitorable", true)
	$Hurtbox.call_deferred("set", "monitoring", true)
	$Hurtbox.call_deferred("set", "monitorable", true)
	.respawn()
