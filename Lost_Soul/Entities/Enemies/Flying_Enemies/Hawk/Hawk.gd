extends Base_Fly

func _hit(damage : int, force : int, direction : Vector2):
	self.speed += force*direction.normalized()
	self._change_state($States/Knockback)
