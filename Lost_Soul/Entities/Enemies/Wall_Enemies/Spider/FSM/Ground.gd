extends State

export(bool) var can_jump : bool #set Jump animation

func enter(Spider : KinematicBody2D) -> void:
	Spider.change_animation("Jump")
	Spider.align_floor()
	can_jump = false

func update(Spider: KinematicBody2D, _delta : float) -> void:
	if can_jump:
		Spider._change_state($"../Jumping")
