extends FSM

class_name Base_Fly

#Information
onready var body : Node2D = $Body
var hero : KinematicBody2D

func _ready():
	cur_state = $States/Idle
	cur_state.enter(self)

#Movement
var speed : Vector2 = Vector2(0,0)

#Functions
func change_animation(anim : String) -> void:
	$Body_Animations.play(anim)

#Base_Functions
func _input(_event):
	#NPCs ignore inputs (most of the times)
	pass
