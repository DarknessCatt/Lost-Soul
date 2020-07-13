extends ConcurrentState

enum {Stop, Walk, Jump, Fall}
var cur_state : int = 0

func enter(Machine : Node, Player : KinematicBody2D) -> void:
	match(Machine.move_state.name):
			"OnGround":
				if Player.speed.x == 0:
					cur_state = Stop
					Player._change_anim("Rest")

				else:
					cur_state = Walk
					Player._change_anim("Walking")

			"Jumping":
				cur_state = Jump
				Player._change_anim("Jumping")

			"Falling":
				cur_state = Fall
				Player._change_anim("Falling")

func exit(Machine : Node, Player : KinematicBody2D) -> void:
	pass

func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:
	if cur_state == Stop and Player.speed.x != 0:
		cur_state = Walk
		Player._change_anim("Walking")

	elif cur_state == Walk and Player.speed.x == 0:
		cur_state = Stop
		Player._change_anim("Rest")

func input(Machine : Node, Player: KinematicBody2D, event : InputEvent) -> void:
	pass

func move_state_changed(Machine : Node, Player: KinematicBody2D) -> void:
	match(Machine.move_state.name):
			"OnGround":
				if Player.speed.x == 0:
					cur_state = Stop
					Player._change_anim("Rest")

				else:
					cur_state = Walk
					Player._change_anim("Walking")

			"Jumping":
				cur_state = Jump
				Player._change_anim("Jumping")

			"Falling":
				cur_state = Fall
				Player._change_anim("Falling")
