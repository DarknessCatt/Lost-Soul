extends State

func enter(Spitter : KinematicBody2D) -> void:
	Spitter.change_animation("Dead")
