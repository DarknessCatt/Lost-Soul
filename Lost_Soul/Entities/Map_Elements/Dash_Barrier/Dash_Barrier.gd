extends StaticBody2D

func _on_Player_entered(body):
	$Barrier.scale.x = sign(self.global_position.x - body.position.x)
	$Animation.play("entered")
