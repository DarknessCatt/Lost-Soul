extends State

func enter(Spitter : KinematicBody2D) -> void:
	Spitter.change_animation("Spit")

func update(Spitter: KinematicBody2D, _delta : float) -> void:
	if Spitter.vision.get_collider() == null:
		Spitter._change_state($"../Idle")
