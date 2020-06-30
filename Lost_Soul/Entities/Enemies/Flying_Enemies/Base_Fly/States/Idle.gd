extends State

#State info
export(String) var state_anim : String = "Idle"

var hero : KinematicBody2D
onready var eyes : RayCast2D = $"../../Perception/Eyes"

#Mini FSM
var detected : bool = false

#Functions
func enter(base_fly : KinematicBody2D) -> void:
	base_fly.change_animation(state_anim)
	base_fly.hero = null

func update(base_fly: KinematicBody2D, _delta : float) -> void:
	if detected:
		eyes.cast_to = (hero.global_position - eyes.global_position)
		eyes.force_raycast_update()
		if eyes.get_collider() == null:
			base_fly.hero = hero
			base_fly._change_state($"../Flying")

func _on_Player_Detected(body):
	hero = body
	detected = true

func _on_Player_Exited(_body):
	detected = false
