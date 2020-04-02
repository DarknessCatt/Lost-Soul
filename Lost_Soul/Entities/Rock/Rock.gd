extends StaticBody2D

func _hit(_damage : int, force : int, direction : Vector2):
	if _damage >= 10:
		$Collision.call_deferred("set", "disabled", true)
		$Body.hide()
		$Shatter.emitting = true
