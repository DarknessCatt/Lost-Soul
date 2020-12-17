extends Base_Fly

var can_attack : bool = true

func _hit(damage : int, force : int, direction : Vector2):
	self.health -= damage
	self.speed += force*direction.normalized()
	if self.health > 0:
		self._change_state($States/Knockback)
	else:
		self.spawn_souls()
		self._change_state($States/Dead)

func _on_Atk_CD_timeout():
	can_attack = true

func respawn() -> void:
	self.set_collision_layer_bit(1, 1)
	$Body/Middle_Body/Hurtbox.call_deferred("set", "monitoring", true)
	$Body/Middle_Body/Hurtbox.call_deferred("set", "monitorable", true)
	$Body/Middle_Body/Hitbox.call_deferred("set", "monitoring", true)
	$Body/Middle_Body/Hitbox.call_deferred("set", "monitorable", true)
	$Body.modulate = Color(1,1,1,1)
	$Body/Middle_Body/Head/Eye.modulate = Color(1,1,1,1)
	.respawn()

func _on_Hero_Hit(body):
	self.speed = (self.global_position-body.global_position).normalized()*700
