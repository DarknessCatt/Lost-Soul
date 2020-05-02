extends Base_Wanderer

#Attributes
export(int) var max_health = 20
var health = max_health

const invencible = false

func _hit(_damage : int, force : int, direction : Vector2):
	self.speed = force*direction.normalized()

	health -= _damage

	self._change_state($States/Knockback)

	if health < 0:
		self._change_state($States/Dead)
	else:
		self._change_state($States/Knockback)
