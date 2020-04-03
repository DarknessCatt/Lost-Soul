extends Area2D


func _on_Crystal_Heart_body_entered(_body):
	$Animation/AnimationTree["parameters/Transition/current"] = 1
	$Collect_Area.call_deferred("set", "disabled", true)
	_body._crystal_heart_collected()

func _on_Collected_Finished():
	self.call_deferred('free')
