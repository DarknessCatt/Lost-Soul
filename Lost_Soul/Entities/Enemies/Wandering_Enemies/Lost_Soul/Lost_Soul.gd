extends Base_Wanderer

#Attributes
export(int) var max_health = 20
var health = max_health

const invencible = false

func _hit(_damage : int, force : int, direction : Vector2):

	if direction.y != 0:
		self.speed = force*direction.normalized()
	else:
		self.speed.x = force*direction.normalized().x

	$Misc_Animations.play("hit")

	#health -= _damage

	if health < 0:
		self._change_state($States/Dead)
