extends "res://Classes/FSM.gd"

#Information
onready var body : Node2D = $Body

func _ready():
	cur_state = $States/Walking
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
