extends Base_Fly

#Attributes
func _hit(_damage : int, force : int, direction : Vector2):

	self.speed += force*direction.normalized()

	$Misc_Animations.play("hit")

	health -= _damage

	if health <= 0:
		self._change_state($States/Dead)
		self.spawn_souls()

func _physics_process(delta):
	if cur_state.name == "Flying":
		$States/Hero_Tracker.update(self, delta)

	cur_state.update(self, delta)
