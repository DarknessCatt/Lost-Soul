extends StaticBody2D

export(int, 0, 999) var hits : int = 3

const invencible : bool = false
const shake_var : float = 15.0

onready var original_pos : Vector2 = self.position

func _hit(_damage : int, _force : int, _direction : Vector2) -> void:
	self.hits -= 1
	
	if self.hits >= 0:
		$Hit_Sound.play()
		$Shake_Duration.start()
		$Shake_Proc.start()

func _on_Shake_Proc_timeout():
	self.position = self.original_pos
	self.position.x += rand_range(-shake_var, shake_var)
	self.position.y += rand_range(-shake_var, shake_var)

func _on_Shake_Duration_timeout():
	$Shake_Duration.stop()
	$Shake_Proc.stop()
	self.position = self.original_pos

	if self.hits <= 0:
		self.call_deferred("free")
