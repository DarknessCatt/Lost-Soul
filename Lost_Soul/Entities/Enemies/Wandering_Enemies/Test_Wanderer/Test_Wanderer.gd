extends Base_Wanderer

func _hit(_damage : int, force : int, direction : Vector2):
	self.speed = direction.normalized()*force
	$Misc_Animations.play("hit")

	health -= _damage

	if health > 0:
		self._change_state($States/Knockback)

	else:
		self._change_state($States/Dead)
