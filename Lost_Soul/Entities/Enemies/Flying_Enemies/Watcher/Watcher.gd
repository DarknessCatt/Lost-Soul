extends Base_Fly

#Attributes
func _hit(_damage : int, force : int, direction : Vector2):

	self.speed += force*direction.normalized()

	health -= _damage

	if health <= 0:
		self._change_state($States/Dead)
		self.spawn_souls()

	else:
		$Misc_Animations.play("hit")

func _physics_process(delta):
	if cur_state.name == "Flying":
		$States/Hero_Tracker.update(self, delta)

	cur_state.update(self, delta)

func respawn() -> void:
	self.modulate = Color("ffffff")
	self.rotation = 0
	$Body/Eye.position = Vector2(0,0)
	$Body/Eye.scale = Vector2(1,1)
	$Body/Eye/Iris.polygon = PoolVector2Array([Vector2(0,-8),Vector2(8,0),Vector2(0,8),Vector2(-8,0)])
	$Body/Eye/Iris.color = Color("3b0505")
	$Body/Eye/Hitbox.call_deferred("set", "monitorable", true)
	$Hurtbox.call_deferred("set", "monitoring", true)
	.respawn()
