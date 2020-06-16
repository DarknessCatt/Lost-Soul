extends FSM

#Information
var body : Node2D
var hero : KinematicBody2D
onready var animation : AnimationNodeStateMachinePlayback = \
		$Animation_Player.get("parameters/playback")
onready var effects : AnimationPlayer = $Body_Effects

export(int) var horizontal_space = 0
export(int) var downwards_space = 0

#Signals
signal intro_ended

const invencible : bool = false

##Functions
func _hit(damage : int, force : int, direction : Vector2) -> void:
	cur_state.hit(damage, force, direction)

func _ready():
	body = $Body
	cur_state = $States/Idle
	self.modulate.a = 0

func _input(_event):
	pass

func intro(player : KinematicBody2D):
	hero = player
	cur_state = $States/Intro
	$Animation_Player.active = true
	cur_state.enter(self)
