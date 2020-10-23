extends Base_Fly

#Attributes
func _hit(damage : int, force : int, direction : Vector2):

	self.speed += force*direction.normalized()

	$Misc_Animations.play("hit")

	health -= damage

	if health <= 0:
		self._change_state($States/Dead)
		self.spawn_souls()

func respawn() -> void:
	self.set_collision_layer_bit(1, 1)
	$Body/Wisp.rotation = 0
	$Body/Wisp.scale.y = 1
	$Body/Wisp.position.y = 0
	self.modulate = Color("ffffff")
	$Body/Wisp/Hitbox.call_deferred("set", "monitorable", true)
	$Body/Wisp/Hurtbox.call_deferred("set", "monitoring", true)
	$Body/Wisp/Hurtbox.call_deferred("set", "monitorable", true)
	.respawn()
