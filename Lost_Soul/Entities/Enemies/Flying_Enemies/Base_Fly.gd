extends Enemy_FSM

class_name Base_Fly

#Information
onready var body : Node2D = $Body
var hero : KinematicBody2D

func _ready():
	cur_state = $States/Idle
	cur_state.enter(self)

#Functions
func change_animation(anim : String) -> void:
	$Body_Animations.play(anim)

func respawn() -> void:
	hero = null
	self._change_state($States/Idle)
	.respawn()
