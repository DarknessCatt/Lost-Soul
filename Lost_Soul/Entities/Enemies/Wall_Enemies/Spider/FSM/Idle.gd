extends State

var Player : KinematicBody2D = null
onready var LoS : RayCast2D = $"../../Perception/LoS"

func enter(Spider : KinematicBody2D) -> void:
	Spider.change_animation("Idle")
	LoS.enabled = true

func exit(Spider : KinematicBody2D) -> void:
	LoS.enabled = false
	Spider.Player = Player

func update(Spider: KinematicBody2D, _delta : float) -> void:
	if Player != null:
		LoS.cast_to = (Player.global_position - LoS.global_position)
		LoS.force_raycast_update()
		if LoS.get_collider() == null:
			Spider._change_state($"../Attacking")

func _on_FoV_entered(body):
	Player = body

func _on_FoV_exited(_body):
	Player = null
