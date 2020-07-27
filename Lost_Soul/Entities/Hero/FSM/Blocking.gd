extends ConcurrentState

func enter(_Machine : Node, Player : KinematicBody2D) -> void:
	Player._change_anim("Block_Stand")
	Player.blocking = true

func exit(_Machine : Node, Player : KinematicBody2D) -> void:
	Player._clear_attack_polys()
	Player.blocking = false

#func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:
#	pass

func input(Machine : Node, _Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_pressed("hero_attack"):
		Machine.change_action_state($"../Attack")

	elif event.is_action_released("hero_block"):
		Machine.change_action_state($"../Idle")

func move_state_changed(_Machine : Node, _Player: KinematicBody2D) -> void:
	pass
