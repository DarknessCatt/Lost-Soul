extends Base_Fly

#Attributes
export(int) var max_health : int = 25
var health : int = max_health

var invencible : bool = false

func _hit(_damage : int, force : int, direction : Vector2):

	self.speed += force*direction.normalized()

	$Body_Animations.play("hit")

	health -= _damage

	if health <= 0:
		self._change_state($States/Dead)

func _physics_process(delta):
	if cur_state.name == "Flying":
		$States/Hero_Tracker.update(self, delta)

	cur_state.update(self, delta)
