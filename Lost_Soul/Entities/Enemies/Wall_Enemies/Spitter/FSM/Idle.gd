extends State

func enter(Spitter : KinematicBody2D) -> void:
	Spitter.change_animation("Idle")

func update(Spitter: KinematicBody2D, _delta : float) -> void:
	if Spitter.vision.get_collider() != null:
		Spitter._change_state($"../Attacking")
