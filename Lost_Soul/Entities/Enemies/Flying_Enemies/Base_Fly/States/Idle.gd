extends State

#State info
export(String) var state_anim : String = "Idle"

var hero : KinematicBody2D
onready var eyes : RayCast2D = $"../../Perception/Eyes"

#Mini FSM
var detected : bool = false

#Functions
func enter(_Player : KinematicBody2D) -> void:
	_Player.change_animation(state_anim)
	_Player.hero = null

func update(_Player: KinematicBody2D, _delta : float) -> void:
	if detected:
		eyes.cast_to = (hero.global_position - eyes.global_position)
		eyes.force_raycast_update()
		if eyes.get_collider() == null:
			_Player.hero = hero
			_Player._change_state($"../Flying")

func _on_Player_Detected(body):
	hero = body
	detected = true

func _on_Player_Exited(body):
	detected = false
