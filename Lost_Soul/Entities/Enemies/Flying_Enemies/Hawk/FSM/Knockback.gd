extends State

var ended : bool = false

#Movement
const NORMAL : Vector2 = Vector2(0, -1)
const FRICTION : float = 0.9

#Functions
func enter(Hawk : KinematicBody2D) -> void:
	Hawk.change_animation("Rising")
	Hawk.body.scale.x = -1*sign(Hawk.speed.x)
	Hawk.speed.y = min(-1000, Hawk.speed.y)

	ended = false
	$Timer.start()

func update(Hawk: KinematicBody2D, delta : float) -> void:
	# warning-ignore:return_value_discarded
	Hawk.move_and_slide(Hawk.speed, NORMAL)
	Hawk.speed *= FRICTION

	if ended:
		Hawk.speed = Vector2.ZERO
		Hawk._change_state($"../Idle")

func _on_timeout():
	ended = true
