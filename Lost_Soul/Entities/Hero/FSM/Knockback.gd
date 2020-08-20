extends State

const NORMAL : Vector2 = Vector2(0, -1)

const GRAV : int = 3500
const MAX_GRAV : int = 1500
const FRICTION : float = 0.8

var knockback_over : bool = false

func enter(Player : KinematicBody2D) -> void:
	Player.invencible = true
	Player._change_anim("OnHit")
	knockback_over = false
	$Inv_Timer.start()

func exit(Player : KinematicBody2D) -> void:
	Player.speed = Vector2.ZERO

func update(Player: KinematicBody2D, delta : float) -> void:
	if knockback_over:
		Player._change_state($"../Playing")

	else:
		var spd : Vector2 = Player.speed

		spd.x *= FRICTION

		spd.y += GRAV*delta
		if spd.y > MAX_GRAV: spd.y = MAX_GRAV

		Player.speed = spd

		# warning-ignore:return_value_discarded
		Player.move_and_slide(Player.speed, NORMAL)

func _anim_done():
	knockback_over = true
