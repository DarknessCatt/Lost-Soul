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
