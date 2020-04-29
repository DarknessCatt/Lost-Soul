extends KinematicBody2D

#FSM
onready var cur_state : Node
export(bool) var on_cutscene : bool = false

##Functions
func _input(event):
	cur_state.input(self, event)

func _physics_process(delta):
	cur_state.update(self, delta)

func _change_state(new_state : Node):
	cur_state.exit(self)
	cur_state = new_state
	cur_state.enter(self)
