extends ConcurrentState

var energy_timer : float = 0.0

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

	if Player.speed.x != 0:
		Player.body.scale.x = sign(Player.speed.x)

	energy_timer = 0.0

func exit(Machine : Node, Player : KinematicBody2D) -> void:
	pass

func update(Machine : Node, Player: KinematicBody2D, delta : float) -> void:
	if cur_state == Stop and Player.speed.x != 0:
		cur_state = Walk
		Player._change_anim("Walking")

	elif cur_state == Walk and Player.speed.x == 0:
		cur_state = Stop
		Player._change_anim("Rest")

	energy_timer += delta

	while energy_timer >= 1:
		Player.energy += 1
		energy_timer -= 1

func input(Machine : Node, Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_pressed("hero_attack"):
		Machine.change_action_state($"../Attack")

	elif event.is_action_pressed("hero_block"):
		Machine.change_action_state($"../Blocking")

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
