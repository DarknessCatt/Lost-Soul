extends Base_Fly

#Attributes
func _hit(_damage : int, force : int, direction : Vector2):

	self.speed += force*direction.normalized()

	$Misc_Animations.play("hit")

	health -= _damage

	if health <= 0:
		self._change_state($States/Dead)

