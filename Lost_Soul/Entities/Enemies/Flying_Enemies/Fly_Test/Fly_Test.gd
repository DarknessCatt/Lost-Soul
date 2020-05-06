extends Base_Fly

#Attributes
export(int) var max_health : int = 7
var health : int = max_health

var invencible : bool = false

func _hit(_damage : int, force : int, direction : Vector2):


	self.speed += force*direction.normalized()

	$Misc_Animations.play("hit")

	health -= _damage

	if health <= 0:
		self._change_state($States/Dead)

