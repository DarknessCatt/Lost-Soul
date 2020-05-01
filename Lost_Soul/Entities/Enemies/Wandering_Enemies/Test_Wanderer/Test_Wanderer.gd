extends Base_Wanderer

var invencible = false

func _hit(_damage : int, force : int, direction : Vector2):
	#invencible = true
	self.speed = direction.normalized()*force
	#$Animation.play("Hit")
