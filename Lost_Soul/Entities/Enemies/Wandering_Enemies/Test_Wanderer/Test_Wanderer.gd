extends Base_Wanderer

#Attributes
export(int) var max_health = 15
var health = max_health

const invencible = false

func _hit(_damage : int, force : int, direction : Vector2):
	self.speed = direction.normalized()*force
	$Misc_Animations.play("hit")

	health -= _damage

	if health > 0:
		self._change_state($States/Knockback)

	else:
		self._change_state($States/Dead)
