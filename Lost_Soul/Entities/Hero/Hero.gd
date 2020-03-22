extends KinematicBody2D

#Info
onready var body : Node2D = $Body

#Movement
var speed : Vector2 = Vector2(0,0)

#FSM
onready var cur_state : Node  = $States/Falling

func _input(event):
	cur_state.input(self, event)

func _physics_process(delta):
	cur_state.update(self, delta)

func _change_state(new_state : Node):
	cur_state.exit(self)
	cur_state = new_state
	cur_state.enter(self)

func _change_anim(new_anim : String):
	if $Animations.current_animation != new_anim:
		$Animations.play(new_anim)
