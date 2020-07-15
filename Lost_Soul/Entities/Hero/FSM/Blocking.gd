extends ConcurrentState

func enter(_Machine : Node, Player : KinematicBody2D) -> void:
	Player._change_anim("Block_Stand")

func exit(_Machine : Node, Player : KinematicBody2D) -> void:
	Player._clear_attack_polys()

#func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:
#	pass

func input(Machine : Node, _Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_released("hero_block"):
		Machine.change_action_state($"../Idle")

func move_state_changed(Machine : Node, Player: KinematicBody2D) -> void:
	pass
