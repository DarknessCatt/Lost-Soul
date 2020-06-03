extends StaticBody2D


export(int) var health : int = 3

var shake_num : int = 0

func _on_Hurtbox_area_entered(_area):
	health -= 1
	if health <= 0:
		$phys_body.call_deferred("set", "disabled", true)
		$Body.hide()
		$Break_Particles.scale = Vector2(1,1)/self.scale
		var particles : ParticlesMaterial = $Break_Particles.process_material
		particles.emission_box_extents.x = 30*self.scale.x
		particles.emission_box_extents.y = 30*self.scale.y
		$Break_Particles.emitting = true

	else:
		$Shake_Timer.start()
		shake_num = 0

func _on_Shake_Timer_timeout():
	shake_num += 1

	if shake_num < 5:
		$Body.position = Vector2(rand_range(-5,5),rand_range(-5,5))

	else:
		$Body.position = Vector2(0,0)
		shake_num = 0
		$Shake_Timer.stop()
