extends State

const DASH_SPEED : int  = 3000
export(PackedScene) var GHOST_SCENE : PackedScene

var dash_over : bool = false

var GHOST_TIMEOUT : float
var ghost_timer : float = 0.0

func enter(Player : KinematicBody2D) -> void:
	var dash_dir : float = Input.get_action_strength("hero_right") - \
							Input.get_action_strength("hero_left")

	if dash_dir == 0: dash_dir = Player.body.scale.x

	Player.speed = Vector2(dash_dir*DASH_SPEED, 0)

	ghost_timer = 0.0
	GHOST_TIMEOUT = 0.0001

	dash_over = false
	Player._change_anim("Dashing")
	$Dash_Timer.start()

func exit(Player : KinematicBody2D) -> void:
	Player.speed = Vector2.ZERO
	Player.body.modulate = Color(1,1,1)

func update(Player: KinematicBody2D, delta : float) -> void:
	if dash_over:
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

		Player.move_and_slide(Player.speed)
		Player.speed *= 0.8

func _on_Dash_timeout():
	dash_over = true
