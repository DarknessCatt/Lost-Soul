extends "BasicMove.gd"

func enter(Machine : Node, Player : KinematicBody2D) -> void:
	Player.speed.y = 200
	.enter(Machine, Player)

func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:

	.update(Machine, Player, delta)

	if not Player.is_on_floor():
		Player.buffer._coyote_timer()
		Machine.change_move_state($"../Falling")


func input(Machine : Node, _Player: KinematicBody2D, event : InputEvent) -> void:

	if event.is_action_pressed("hero_jump"):
		Machine.change_move_state($"../Jumping")
