extends FSM

#Information
var body : Node2D
var Player : KinematicBody2D
onready var animation : AnimationNodeStateMachinePlayback = \
		$Animation_Player.get("parameters/playback")

#Signals
signal intro_ended

##Functions
func _ready():
	body = $Body
	cur_state = $States/Intro
	$Animation_Player.active = true
	cur_state.enter(self)

func _input(_event):
	pass
