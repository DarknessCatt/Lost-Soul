extends Area2D

func _on_Crystal_Heart_body_entered(_body):
	$Animation/AnimationTree["parameters/Transition/current"] = 1

func _on_Collected_Finished():
	self.call_deferred('free')
