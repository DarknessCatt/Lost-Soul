extends State

const DASH_SPEED : int  = 2000

var dash_over : bool = false

func enter(Player : KinematicBody2D) -> void:
	var dash_dir : float = Input.get_action_strength("hero_right") - \
							Input.get_action_strength("hero_left")

	if dash_dir == 0: dash_dir = Player.body.scale.x

	Player.speed = Vector2(dash_dir*DASH_SPEED, 0)

	dash_over = false
	Player._change_anim("Dashing")
	$Dash_Timer.start()

func exit(Player : KinematicBody2D) -> void:
	Player.speed = Vector2.ZERO

func update(Player: KinematicBody2D, _delta : float) -> void:
	if dash_over:
		Player._change_state($"../Playing")

	else:
		Player.move_and_slide(Player.speed)
		Player.speed *= 0.95

func _on_Dash_timeout():
	dash_over = true
