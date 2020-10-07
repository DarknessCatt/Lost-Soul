extends State

const DASH_SPEED : int  = 2000
export(PackedScene) var GHOST_SCENE : PackedScene

var dash_over : bool = false

var GHOST_TIMEOUT : float
var ghost_timer : float = 0.0

func enter(Player : KinematicBody2D) -> void:
	var dash_dir : float = sign(Input.get_action_strength("hero_right") - \
							Input.get_action_strength("hero_left"))

	if dash_dir == 0: dash_dir = Player.body.scale.x

	Player.body.scale.x = dash_dir
	Player.speed = Vector2(dash_dir*DASH_SPEED, 10)

	ghost_timer = 0.0
	GHOST_TIMEOUT = 0.0001

	dash_over = false
	Player._reset_anim("Dashing")
	$Dash_Timer.start()

func exit(Player : KinematicBody2D) -> void:
	Player.body.modulate = Color(1,1,1)

func update(Player: KinematicBody2D, delta : float) -> void:
	if dash_over:
		if Player.buffer.dash_buffered and Player.can_dash():
			Player._change_state(self)

		else:
			Player._change_state($"../Playing")

	else:
		ghost_timer += delta
		if ghost_timer >= GHOST_TIMEOUT:
			ghost_timer = 0.0
			GHOST_TIMEOUT += 0.0005
			GHOST_TIMEOUT *= 2

			var new_ghost : Node2D = GHOST_SCENE.instance()
			new_ghost.set_player(Player)
			Player.get_parent().add_child(new_ghost)

		# warning-ignore:return_value_discarded
		Player.move_and_slide(Player.speed, Vector2(0, -1))
		Player.speed *= 0.87

func _on_Dash_timeout():
	dash_over = true

func input(Player: KinematicBody2D, event : InputEvent):
	if event.is_action_pressed("hero_jump"):
		Player.buffer._buffer_jump()

	elif event.is_action_pressed("hero_attack"):
		Player.buffer._buffer_attack()

	elif event.is_action("hero_dash"):
		Player.buffer._buffer_dash()
